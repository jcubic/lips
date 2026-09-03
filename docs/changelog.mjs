#!/usr/bin/env node

import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const source = path.join(__dirname, '../CHANGELOG.md');
const target = path.join(__dirname, 'src/pages/changelog.md');

const front_matter = `---
title: Changelog
description: Release notes for LIPS Scheme - new features, bug fixes, breaking changes, and procedures that were renamed or removed in each version.
keywords: [changelog, release notes, breaking changes, removed, renamed, migration]
# only the version headings in the table of contents - every release repeats
# the same Breaking/Features/Bugfix sections, which just buries the versions
toc_max_heading_level: 2
format: md
---

<!-- GENERATED FILE - edit CHANGELOG.md in the repository root instead. -->

# Changelog

All versions of LIPS Scheme. It includes all features, bugfixes and breaking changes.

`;

const changelog = await fs.readFile(source, 'utf8');

// the changelog has no title of its own - it opens straight at the newest
// version heading - so the heading above is prepended rather than replacing one
await fs.writeFile(target, `${front_matter}\n${changelog.trimStart()}`);
