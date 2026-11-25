-- Run once in Supabase SQL Editor: lets a holder of the secret code below
-- READ feedback (and nothing else). Used by tool/feedback.sh and, later, a
-- review agent. To revoke: delete the row from feedback_reader_token.

create table if not exists public.feedback_reader_token (token text primary key);
alter table public.feedback_reader_token enable row level security;   -- never readable via the API
revoke all on public.feedback_reader_token from anon, authenticated;
insert into public.feedback_reader_token values ('llfb_2nOu7H4_30D4_5R-kPXKwmpcCHDK-bUVq2PXNzHC9O0')
  on conflict do nothing;

create or replace function public.read_feedback(
  reader_token text,
  since timestamptz default now() - interval '30 days'
) returns setof public.feedback
language sql stable security definer set search_path = '' as $$
  select f.* from public.feedback f
  where exists (select 1 from public.feedback_reader_token t where t.token = reader_token)
    and f.created_at >= since
  order by f.created_at desc
  limit 1000;
$$;
revoke all on function public.read_feedback(text, timestamptz) from public;
grant execute on function public.read_feedback(text, timestamptz) to anon, authenticated;
