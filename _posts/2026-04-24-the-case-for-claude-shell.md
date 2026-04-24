---
layout: page
title: The case for claude-shell
date: 2026-04-24 03:00:18+0000
description: Why I built claude-shell and where I think it's going.
tags: [claude, ai, devops, containers, automation]
---

## The Problem

Claude Code is a powerful tool. It can read your codebase, write code, run tests, and iterate
on problems with minimal hand-holding. But it runs on your machine, in your shell, with access
to your filesystem. If you're working on one project, that's fine. If you're working on five
projects at once&mdash;or you want Claude to work on them autonomously while you sleep&mdash;things
get messy fast.

There's no built-in isolation. One session can clobber another's files. A runaway process can
eat your disk or your CPU. And if you're experimenting with something destructive&mdash;say,
a `git reset --hard` or a rogue `rm -rf`&mdash;you'd better hope it's scoped to the right
directory.

I built [claude-shell](https://github.com/sam-caldwell/claude-shell) to fix this.

## What claude-shell Does

The idea is simple: every Claude Code session gets its own Docker container. Each container has
its own filesystem, its own home directory, its own process space. Containers share your Claude
credentials and SSH keys read-only, so authentication just works. But the blast radius of any
single session is confined to its own container.

It's a small Go binary. You run `claude-shell`, it assigns a UUID, spins up a container, and
drops you into an isolated Claude session. You can run as many as your machine can handle. Each
one persists across restarts. Each one is expendable&mdash;if a session goes sideways, kill the
container and start fresh. Your host and your other sessions are untouched.

This is not a platform. It's not a framework. It's a thin wrapper around Docker and the Claude
CLI. The value is in what it *doesn't* do: it doesn't try to be clever, it doesn't add
abstractions, and it doesn't get in the way.

## Why Isolation Matters

If you're a solo developer running one Claude session at a time, you might not need this. But
the moment you want concurrency&mdash;multiple Claude agents working on different parts of a
project, or different projects entirely&mdash;isolation becomes essential.

Consider what happens without it:

- Two sessions try to install conflicting dependencies in the same `node_modules`.
- One session runs `make clean` while another is mid-build.
- A session modifies shared config files that another session depends on.
- A misbehaving session exhausts memory or fills the disk.

Containers solve all of this. They're the same technology that already runs your production
workloads. There's nothing exotic here&mdash;just applying a well-understood isolation primitive
to a new use case.

## The Orchestration Vision

Today, claude-shell runs sessions on a single host. That's the starting point, not the
destination.

The next step is orchestration. Imagine a controller that can distribute Claude Code sessions
across multiple hosts. Each host runs claude-shell. The controller assigns work, monitors
progress, and collects results. The sessions don't know or care where they're running&mdash;they
just see their container, their filesystem, and their task.

This turns Claude from a tool you babysit into a workforce you direct. You define the work
packages: "refactor the auth module," "write integration tests for the payment service," "audit
the dependency tree for known CVEs." The controller fans them out. The sessions execute in
parallel, each in its own isolated environment. You review the results.

This isn't science fiction. It's a scheduling problem, and we have decades of practice solving
scheduling problems.

## Ephemeral Hosts and Cloud Scale

Once sessions can be distributed across hosts, the hosts themselves become fungible. There's no
reason they need to be permanent. Spin up a Digital Ocean droplet, run claude-shell, assign it
a work package, collect the output, tear it down. Pay for compute by the hour, not by the
month.

This is where things get interesting for larger projects. Take something like
[GreyNet](https://github.com/sam-caldwell/greynet)&mdash;a distributed system with multiple
services, protocol layers, and cryptographic components. No single Claude session is going to
build that end-to-end. But twenty sessions, each working on a well-defined component with clear
interfaces? That's tractable.

The workflow would look something like this:

1. Define the architecture and interfaces up front.
2. Break the work into independent packages with clear inputs and outputs.
3. Spin up ephemeral hosts on a cloud provider.
4. Assign each host a work package via claude-shell.
5. Run integration tests as components land.
6. Tear down the hosts.

The cost model is favorable. A modest droplet runs around five dollars a month. If you only need
it for eight hours, that's pennies. The real cost is the Claude API usage, not the compute.

## Why Minimal Matters

There's a temptation, when building tools like this, to keep adding features. Session
management dashboards. Plugin systems. YAML configuration files. Webhook integrations.

I'm resisting that temptation. The power of claude-shell is that it's small enough to
understand in an afternoon and simple enough to trust. The entire codebase is Go. The only
real dependency is Docker. If something breaks, there are very few places to look.

Minimalism is also a security posture. Every feature is an attack surface. Every abstraction is
a place where assumptions can be wrong. A tool that manages AI agents with access to your code
and credentials should be as transparent and auditable as possible.

## Where This Goes

Right now, claude-shell is a local development tool. It makes my daily workflow safer and more
productive. I can spin up a Claude session per project, let them run in parallel, and not worry
about cross-contamination.

In the near term, I want to add multi-host orchestration. A simple controller that can SSH into
remote machines, deploy claude-shell, and coordinate work across them. Nothing fancy&mdash;just
enough to distribute tasks and collect results.

In the medium term, I want ephemeral cloud integration. Provision hosts on demand, run sessions,
tear them down. Make the compute layer as disposable as the containers themselves.

The end state is a development model where I define what needs to be built, and a fleet of
isolated Claude sessions builds it&mdash;distributed across as many hosts as the work
requires, each one sandboxed, each one expendable, each one doing exactly what it's told and
nothing more.

We're not there yet. But the foundation is a twenty-megabyte Go binary and a Dockerfile, and
that's enough to start.
