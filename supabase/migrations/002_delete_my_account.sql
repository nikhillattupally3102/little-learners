-- Run once in Supabase SQL Editor (adds account deletion to an existing setup).
-- Lets a signed-in grown-up delete their own account. Deleting the auth user
-- removes all of the family's children, results and seen rows (on delete
-- cascade). Runs with elevated rights, but only ever touches auth.uid().
create or replace function public.delete_my_account() returns void
language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  delete from auth.users where id = auth.uid();
end $$;

revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
