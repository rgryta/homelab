---
name: update-homelab-repo
description: Use when this repository must be synced with the stack deployed in Dockge (/homelab_stack) - compares compose files, detects renamed services, copies the reformatted compose files without secrets, updates docs, then commits and pushes
---

# Update Homelab Repository

Sync the homelab repository with the deployed stack.

This runs inside the code-server container. There, the deployed Dockge stacks are mounted read-only at `/homelab_stack` and this repository is at `/config/workspace/homelab/homelab`.

## Process

### 1. Pre-flight checks
```bash
cd /config/workspace/homelab/homelab
git fetch origin
git status
```
Ensure on `main` branch and up to date with origin. Abort if uncommitted changes exist.

### 2. Compare compose files
```bash
for dir in /homelab_stack/*/; do
  name=$(basename "$dir")
  if [ -d "services/$name" ]; then
    diff -q "$dir/compose.yaml" "services/$name/compose.yaml" 2>/dev/null || echo "Differs: $name"
  else
    echo "Not in repo: $name"
  fi
done
```

### 2b. Check for renamed services
Services may be renamed in Dockge. Before creating "new" services, check if an existing repo service has identical compose content:
```bash
for dir in /homelab_stack/*/; do
  deployed_name=$(basename "$dir")
  if [ ! -d "services/$deployed_name" ]; then
    # Check all repo services for matching compose content
    for repo_dir in services/*/; do
      repo_name=$(basename "$repo_dir")
      if diff -q "$dir/compose.yaml" "$repo_dir/compose.yaml" &>/dev/null; then
        echo "Rename detected: $repo_name → $deployed_name"
      fi
    done
  fi
done
```
For renames: create new directory, copy compose/env, then check old directory for extra files (README.md, scripts) to preserve before deleting.

### 3. Compare .env files (check for NEW variables only)
```bash
for dir in /homelab_stack/*/; do
  name=$(basename "$dir")
  if [ -f "$dir/.env" ] && [ -f "services/$name/.env" ]; then
    # Extract variable names only
    deployed_vars=$(grep -oP '^[A-Z_]+(?==)' "$dir/.env" | sort)
    repo_vars=$(grep -oP '^[A-Z_]+(?==)' "services/$name/.env" | sort)
    new_vars=$(comm -23 <(echo "$deployed_vars") <(echo "$repo_vars"))
    if [ -n "$new_vars" ]; then
      echo "New vars in $name: $new_vars"
    fi
  fi
done
```

### 4. For each differing compose.yaml
- Show the diff to understand changes
- Copy from deployed to repo: `cp /homelab_stack/<service>/compose.yaml services/<service>/compose.yaml`

### 5. For new .env variables
- Add the variable with empty placeholder to repo .env
- NEVER copy actual secret values to repo

### 6. Check for doc updates needed
Search for references to changed services in:
- `docs/networks.md` - IP addresses
- `README.md` - service descriptions
- `services/<service>/README.md` - service-specific docs

```bash
# Example: if a service was added/removed, check for references
grep -r "<service-name>" docs/ README.md
```

### 7. Commit and push
```bash
git add -A
git diff --stat --staged  # Show what will be committed
git commit -m "<type>(<scope>): <description>"
git push
```

## Commit message conventions
- `feat`: New service or feature
- `fix`: Bug fix
- `chore`: Maintenance, version bumps, removals
- `docs`: Documentation only

## Important rules
1. NEVER commit actual secrets - repo .env files must have empty placeholders
2. Always verify you're on main and up to date before making changes
3. Show diffs before copying to understand what changed
4. Update documentation when services are added/removed
5. Keep commit messages to 2 lines max, no co-author notes
6. Before deleting old service directories (renames), check for extra files (README.md, scripts) and copy them to new location
