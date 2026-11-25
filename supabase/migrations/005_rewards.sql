-- Run once in Supabase SQL Editor: stores each child's rewards (on/off,
-- stars spent, stickers collected, grown-up reward goals) so they sync.
alter table public.children
  add column if not exists rewards jsonb not null default '{}'::jsonb;
