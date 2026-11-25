"""Fetches one real-life photo per learning item from Wikipedia / Wikimedia
Commons, with licence + credit, resized for the app.

Usage: python3 -I tool/fetch_photos.py <items.json> <out_dir>
  items.json: [{"topic", "name", ...}]  (dumped from lib/content/topics.dart)
Writes <out_dir>/<topic>__<slug>.jpg and <out_dir>/credits.json.

Only licences that allow use in an app are accepted: public domain, CC0,
CC BY and CC BY-SA (any version). Overrides below pick the Wikipedia article
(or a specific Commons file) for each item.
"""
import html
import json
import os
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request

UA = 'LittleLearnersPhotoFetcher/1.0 (https://little-learners.little-learners.workers.dev; educational kids app)'

# Wikipedia article for each item (default: the item name).
ARTICLE = {
    ('farm', 'Cow'): 'Cattle', ('farm', 'Pig'): 'Domestic pig',
    ('farm', 'Rabbit'): 'Domestic rabbit', ('farm', 'Turkey'): 'Domestic turkey',
    ('farm', 'Duck'): 'Domestic duck', ('farm', 'Goat'): 'Goat',
    ('wild', 'Elephant'): 'African bush elephant', ('wild', 'Zebra'): 'Plains zebra',
    ('wild', 'Monkey'): 'Japanese macaque', ('wild', 'Hippo'): 'Hippopotamus',
    ('wild', 'Rhino'): 'White rhinoceros', ('wild', 'Kangaroo'): 'Red kangaroo',
    ('wild', 'Panda'): 'Giant panda', ('wild', 'Bear'): 'Brown bear',
    ('wild', 'Gorilla'): 'Western gorilla',
    ('ocean', 'Whale'): 'Humpback whale', ('ocean', 'Dolphin'): 'Common bottlenose dolphin',
    ('ocean', 'Shark'): 'Whale shark', ('ocean', 'Octopus'): 'Common octopus',
    ('ocean', 'Crab'): 'Crab', ('ocean', 'Shrimp'): 'Caridea',
    ('ocean', 'Squid'): 'Squid', ('ocean', 'Sea Turtle'): 'Green sea turtle',
    ('ocean', 'Clownfish'): 'Ocellaris clownfish', ('ocean', 'Lobster'): 'American lobster',
    ('ocean', 'Fish'): 'Goldfish',
    ('colors', 'Red'): 'Strawberry', ('colors', 'Orange'): 'Pumpkin',
    ('colors', 'Yellow'): 'Common sunflower', ('colors', 'Green'): 'Leaf',
    ('colors', 'Blue'): 'Sky', ('colors', 'Purple'): 'Eggplant',
    ('colors', 'Brown'): 'Chocolate', ('colors', 'Black'): 'Night sky',
    ('colors', 'White'): 'Snow', ('colors', 'Pink'): 'Cherry blossom',
    ('space', 'Mercury'): 'Mercury (planet)', ('space', 'Earth'): 'Earth',
    ('space', 'Moon'): 'Moon', ('space', 'Sun'): 'Sun',
    ('countries', 'India'): 'Taj Mahal', ('countries', 'United States'): 'Statue of Liberty',
    ('countries', 'United Kingdom'): 'Big Ben', ('countries', 'Japan'): 'Mount Fuji',
    ('countries', 'China'): 'Great Wall of China', ('countries', 'Brazil'): 'Amazon rainforest',
    ('countries', 'Egypt'): 'Giza pyramid complex', ('countries', 'Australia'): 'Sydney Opera House',
    ('countries', 'Canada'): 'Niagara Falls', ('countries', 'Mexico'): 'Chichen Itza',
    ('countries', 'France'): 'Eiffel Tower', ('countries', 'Kenya'): 'Maasai Mara',
    ('body', 'Eyes'): 'Human eye', ('body', 'Ears'): 'Ear', ('body', 'Nose'): 'Human nose',
    ('body', 'Mouth'): 'Smile', ('body', 'Tongue'): 'Tongue', ('body', 'Teeth'): 'Human tooth',
    ('body', 'Hand'): 'Hand', ('body', 'Foot'): 'Foot', ('body', 'Brain'): 'Human brain',
    ('body', 'Bones'): 'Human skeleton', ('body', 'Leg'): 'Human leg',
    ('body', 'Muscles'): 'Bodybuilding',
    ('fruits', 'Orange'): 'Orange (fruit)', ('fruits', 'Grapes'): 'Grape',
    ('fruits', 'Cherries'): 'Cherry', ('fruits', 'Kiwi'): 'Kiwifruit',
    ('veggies', 'Corn'): 'Corn on the cob', ('veggies', 'Chili Pepper'): 'Chili pepper',
    ('veggies', 'Sweet Potato'): 'Sweet potato',
    ('vehicles', 'Fire Truck'): 'Fire engine', ('vehicles', 'Ship'): 'Cruise ship',
    ('vehicles', 'Sailboat'): 'Sailboat', ('vehicles', 'Rocket'): 'Rocket',
    ('vehicles', 'Train'): 'Train', ('vehicles', 'Airplane'): 'Airliner',
    ('bugs', 'Bee'): 'Western honey bee', ('bugs', 'Ladybug'): 'Coccinella septempunctata',
    ('bugs', 'Butterfly'): 'Monarch butterfly', ('bugs', 'Cricket'): 'Cricket (insect)',
    ('bugs', 'Spider'): 'Jumping spider', ('bugs', 'Ant'): 'Ant',
    ('birds', 'Owl'): 'Barn owl', ('birds', 'Eagle'): 'Bald eagle',
    ('birds', 'Parrot'): 'Scarlet macaw', ('birds', 'Penguin'): 'Emperor penguin',
    ('birds', 'Flamingo'): 'American flamingo', ('birds', 'Peacock'): 'Indian peafowl',
    ('birds', 'Swan'): 'Mute swan', ('birds', 'Rooster'): 'Rooster',
    ('birds', 'Dove'): 'Rock dove', ('birds', 'Duck'): 'Mallard', ('birds', 'Turkey'): 'Wild turkey',
    ('sports', 'Soccer'): 'Association football', ('sports', 'Football'): 'American football',
    ('sports', 'Cricket'): 'Cricket', ('sports', 'Bowling'): 'Ten-pin bowling',
    ('sports', 'Table Tennis'): 'Table tennis', ('sports', 'Ice Hockey'): 'Ice hockey',
    ('helpers', 'Doctor'): 'Physician', ('helpers', 'Police Officer'): 'Police officer',
    ('helpers', 'Mail Carrier'): 'Mail carrier', ('helpers', 'Builder'): 'Construction worker',
    ('helpers', 'Pilot'): 'Aircraft pilot',
}


# Items where the article's main photo didn't suit small children (wrong
# subject, old painting, unclear): search Commons with these words instead.
SEARCH = {
    ('colors', 'Blue'): 'blue sky white clouds',
    ('veggies', 'Broccoli'): 'broccoli head isolated',
    ('fruits', 'Kiwi'): 'kiwifruit cut half',
    ('veggies', 'Lettuce'): 'lettuce head',
    ('helpers', 'Doctor'): 'pediatrician examining child',
    ('helpers', 'Chef'): 'chef cooking restaurant kitchen',
    ('helpers', 'Mail Carrier'): 'mail carrier delivering mail',
    ('helpers', 'Teacher'): 'teacher reading to children classroom',
    ('helpers', 'Pilot'): 'airline pilots cockpit',
    ('helpers', 'Scientist'): 'scientist laboratory microscope',
    ('helpers', 'Artist'): 'painter painting on easel',
    ('sports', 'Bowling'): 'ten-pin bowling pins strike',
    ('sports', 'Cricket'): 'cricket batsman batting',
}

# Hand-picked Commons files (chosen after reviewing candidates).
FILE = {
    ('land', 'Island'): 'Aerial View, Sanshan Island, Hailing Island, Jiangcheng District, Yangjiang City.jpg',
    ('land', 'Ocean'): 'Ponta do Pargo (Madeira, Portugal), Farol da Ponta do Pargo, Blick auf den Atlantik -- 2025 -- 1805.jpg',
    # Recognisable space photos (white-light Sun looked like a planet;
    # Uranus and Neptune looked the same).
    ('space', 'Sun'): "The Sun by the Atmospheric Imaging Assembly of NASA's Solar Dynamics Observatory - 20100819.jpg",
    ('space', 'Saturn'): 'Saturn - April 25 2016 (37612580000).png',
    ('space', 'Neptune'): 'Neptune Full.jpg',
    ('space', 'Uranus'): "Uranus as seen by NASA's Voyager 2 (remastered) - JPEG converted.jpg",
    ('space', 'Venus'): 'Venus globe.jpg',
    ('veggies', 'Broccoli'): 'Brocoli 03.jpg',
    ('veggies', 'Lettuce'): "Lactuca sativa 'Ashbrook'.jpg",
    ('colors', 'Blue'): 'Cirrus uncinus clouds in the morning sky.jpg',
    ('sports', 'Cricket'): 'Cricketer bowled.jpg',
    ('helpers', 'Doctor'): 'A Continuing Promise 2015 physician examines a child.jpg',
    ('helpers', 'Teacher'): 'Free Education for Underprivileged children.jpg',
    ('helpers', 'Chef'): 'Chef Vijaya Raghavan.jpg',
    ('helpers', 'Pilot'): 'DFC 5867 Cockpit of a vintage commercial airliner showing flight instruments controls and the pilots seat.jpg',
    ('helpers', 'Scientist'): 'Engin Umut Akkaya - In the Lab.JPG',
    ('helpers', 'Artist'): 'Self portrait as a painter - Vincent van Gogh.jpg',
}

# No photo: hard to show nicely for toddlers (the drawing stays).
SKIP = {('body', 'Brain'), ('body', 'Muscles'), ('body', 'Nose'),
        ('body', 'Leg'), ('body', 'Tongue'),
        # No good modern photo on Commons:
        ('sports', 'Bowling'), ('helpers', 'Mail Carrier')}

ALLOWED = re.compile(r'^(public domain|pd|cc0|cc[- ]by(-sa)?( [0-9.]+)?( [a-z]+)?)', re.I)


def get(url):
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=40) as r:
                return r.read()
        except Exception as e:  # rate limits / hiccups
            if attempt == 3:
                raise
            time.sleep(2 + attempt * 3)


def api(base, **params):
    params.update(format='json', formatversion='2')
    return json.loads(get(base + '?' + urllib.parse.urlencode(params)))


def lead_image(article):
    d = api('https://en.wikipedia.org/w/api.php', action='query', prop='pageimages',
            piprop='name', titles=article, redirects='1', pilicense='free')
    pages = d['query']['pages']
    return pages[0].get('pageimage') if pages else None


def file_info(name):
    d = api('https://commons.wikimedia.org/w/api.php', action='query',
            titles='File:' + name, prop='imageinfo',
            iiprop='url|extmetadata|mime|size', iiurlwidth='720')
    pages = d['query']['pages']
    if not pages or 'imageinfo' not in pages[0]:
        return None
    ii = pages[0]['imageinfo'][0]
    meta = ii.get('extmetadata', {})
    def m(k):
        v = meta.get(k, {}).get('value', '')
        return html.unescape(re.sub(r'<[^>]+>', '', v)).strip()
    return {
        'file': name,
        'mime': ii.get('mime'),
        'width': ii.get('width'), 'height': ii.get('height'),
        'thumb': ii.get('thumburl'),
        'source': ii.get('descriptionurl'),
        'license': m('LicenseShortName'),
        'license_url': meta.get('LicenseUrl', {}).get('value', ''),
        'artist': m('Artist') or m('Credit') or 'Unknown',
        'restrictions': m('Restrictions'),
    }


def acceptable(info):
    if not info or info['mime'] not in ('image/jpeg', 'image/png', 'image/webp'):
        return False
    if not ALLOWED.match(info['license'] or ''):
        return False
    w, h = info['width'] or 0, info['height'] or 0
    return w >= 400 and h >= 300 and 0.5 <= w / max(h, 1) <= 2.2


def search(term):
    d = api('https://commons.wikimedia.org/w/api.php', action='query', list='search',
            srnamespace='6', srsearch=f'{term} filetype:bitmap', srlimit='12')
    return [r['title'][5:] for r in d['query']['search']]


def slug(s):
    return re.sub(r'[^a-z0-9]+', '_', s.lower()).strip('_')


def main():
    items = json.load(open(sys.argv[1]))
    out = sys.argv[2]
    os.makedirs(out, exist_ok=True)
    credits_path = os.path.join(out, 'credits.json')
    credits = json.load(open(credits_path)) if os.path.exists(credits_path) else {}
    for it in items:
        topic, name = it['topic'], it['name']
        if topic == 'numbers' or topic.startswith('abc'):
            continue
        key = f'{topic}__{slug(name)}'
        if key in credits and os.path.exists(os.path.join(out, key + '.jpg')):
            continue
        if (topic, name) in SKIP or topic == 'continents':
            continue  # continents & oceans use globe drawings instead
        article = ARTICLE.get((topic, name), name)
        query = SEARCH.get((topic, name))
        info = None
        lead = FILE.get((topic, name)) or (None if query else lead_image(article))
        if lead:
            info = file_info(lead)
        if not acceptable(info):
            for cand in search(query or article)[:10]:
                info = file_info(cand)
                if acceptable(info):
                    break
            else:
                info = None
        if not info:
            print(f'  ✗ {key}: no suitable photo')
            continue
        raw = os.path.join(out, key + '.src')
        with open(raw, 'wb') as f:
            f.write(get(info['thumb']))
        dst = os.path.join(out, key + '.jpg')
        subprocess.run(['sips', '-s', 'format', 'jpeg', '-s', 'formatOptions', '72',
                        '-Z', '640', raw, '--out', dst], check=True, capture_output=True)
        os.remove(raw)
        credits[key] = {k: info[k] for k in ('file', 'source', 'license', 'license_url', 'artist')}
        credits[key].update(topic=topic, name=name, article=article)
        print(f'  ✓ {key}: {info["file"]} ({info["license"]})')
        json.dump(credits, open(credits_path, 'w'), indent=1, ensure_ascii=False)
        time.sleep(0.4)


if __name__ == '__main__':
    main()
