-- Run once in Supabase SQL Editor: adds feedback collection.
--
-- Anyone using the app (signed in or not) can SEND feedback. Nobody can read
-- it except the admins listed in feedback_admins, who see it in the app's
-- Feedback inbox (or here in the dashboard).

create table if not exists public.feedback (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  parent_id    uuid default auth.uid() references auth.users(id) on delete set null,
  kind         text not null check (kind in ('idea', 'problem', 'content', 'love', 'reaction')),
  rating       int check (rating between 1 and 5),
  message      text check (char_length(message) <= 2000),
  contact      text check (char_length(contact) <= 200),
  -- Where it came from: worksheet kind, level, stars, platform, app version…
  context      jsonb not null default '{}'::jsonb,
  status       text not null default 'new' check (status in ('new', 'seen', 'done')),
  note         text                              -- admin's own note
);
create index if not exists feedback_created_idx on public.feedback(created_at desc);

-- Who may read and triage feedback.
create table if not exists public.feedback_admins (email text primary key);
insert into public.feedback_admins (email) values ('nikhillattupally@gmail.com')
  on conflict do nothing;

alter table public.feedback        enable row level security;
alter table public.feedback_admins enable row level security;  -- no policies: not readable via the API

create or replace function public.is_feedback_admin() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.feedback_admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
grant execute on function public.is_feedback_admin() to anon, authenticated;

drop policy if exists "anyone can send feedback" on public.feedback;
create policy "anyone can send feedback" on public.feedback
  for insert to anon, authenticated
  with check (
    status = 'new' and note is null
    and (parent_id is null or parent_id = auth.uid())
  );

drop policy if exists "admins read feedback" on public.feedback;
create policy "admins read feedback" on public.feedback
  for select to authenticated using (public.is_feedback_admin());

drop policy if exists "admins triage feedback" on public.feedback;
create policy "admins triage feedback" on public.feedback
  for update to authenticated
  using (public.is_feedback_admin()) with check (public.is_feedback_admin());

grant insert on public.feedback to anon, authenticated;
grant select, update on public.feedback to authenticated;
revoke all on public.feedback_admins from anon, authenticated;
