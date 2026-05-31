# Riverpod Overview

## My Goal

I am new to Riverpod, so I want to learn it step by step while building real features.

My approach:
- build one real feature first
- keep the Riverpod code simple
- learn each concept in context
- return to these notes whenever I forget something

## What Riverpod Is Doing

Riverpod helps me manage:
- shared objects like services
- app state
- async data
- dependency access

Instead of creating objects everywhere manually, I define them once as providers and access them with `ref`.

## Mental Model

When I see a provider, I should ask:
- Is this a reusable service?
- Is this mutable state?
- Is this async data or a stream?
- Do I need rebuilds or just a one-time access?

## Learning Plan

For now I should:
- build the real feature first
- use Riverpod only where it helps
- keep the code readable
- come back and review these notes when I get confused

## Next Things I Want To Learn

- when to choose `Provider` vs `NotifierProvider`
- how to structure feature-based state
- how to split API logic from UI
- how loading, success, and error states work
- how to add caching and refresh behavior
