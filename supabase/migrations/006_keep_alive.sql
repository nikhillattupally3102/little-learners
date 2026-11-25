-- Run once in Supabase SQL Editor: a tiny function the daily Cloudflare
-- "keep-alive" job calls, so the free project never pauses for inactivity.
-- It runs a real database query but reveals nothing (just a timestamp).
create or replace function public.keep_alive() returns timestamptz
language sql stable security definer set search_path = '' as $$
  select now() where (select count(*) from public.children) >= 0;
$$;
revoke all on function public.keep_alive() from public;
grant execute on function public.keep_alive() to anon, authenticated;
