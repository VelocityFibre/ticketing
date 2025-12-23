# GitHub Actions Autonomous Support - Setup Guide

**Status**: Ready to deploy
**Cost**: $0 (within free tier)
**Setup time**: ~10 minutes

---

## What This Does

Automatically resolves QFieldCloud support issues when created on GitHub:

1. **Trigger**: New issue created in VelocityFibre/ticketing
2. **Diagnose**: SSH to QFieldCloud VPS, check services
3. **Report**: Post comprehensive diagnostics to issue
4. **Close**: Auto-close if all healthy (or keep open if issues found)

**No manual intervention needed** - fully autonomous.

---

## Setup Steps

### 1. Add GitHub Secrets

Go to your repository settings and add these secrets:

**Path**: `https://github.com/VelocityFibre/ticketing/settings/secrets/actions`

| Secret Name | Value | Where to Get |
|------------|-------|--------------|
| `ANTHROPIC_API_KEY` | `sk-ant-api03-...` | From `.env` file (or Anthropic console) |
| `QFIELD_VPS_SSH_KEY` | Full private key content | `cat ~/.ssh/qfield_vps` |

**For QFIELD_VPS_SSH_KEY**:
```bash
# Copy this entire output:
cat ~/.ssh/qfield_vps

# It should look like:
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
...
-----END OPENSSH PRIVATE KEY-----
```

**GITHUB_TOKEN**: No need to add - automatically provided by GitHub Actions.

### 2. Push Workflow to Repository

```bash
# Commit the workflow files
git add .github/

git commit -m "feat: Add GitHub Actions autonomous support workflow

- Autonomous resolution of QField support issues
- SSH diagnostics to QFieldCloud VPS
- Auto-close when verified healthy
- Free tier usage (0 cost)
- 100% autonomous (no human intervention)"

git push origin main
```

### 3. Enable Workflow (if needed)

1. Go to: `https://github.com/VelocityFibre/ticketing/actions`
2. If workflows are disabled, click "Enable workflows"
3. Find "Autonomous QField Support" workflow
4. Enable it

---

## Testing

### Manual Test (Recommended First)

```bash
# Trigger manually from GitHub Actions UI
# 1. Go to: https://github.com/VelocityFibre/ticketing/actions
# 2. Click "Autonomous QField Support"
# 3. Click "Run workflow"
# 4. Enter issue number: 6 (our test issue)
# 5. Click "Run workflow"

# Watch it run in real-time
```

**Expected**:
- Workflow completes in ~30 seconds
- Posts diagnostic report to issue
- Closes issue if healthy

### Automatic Test

Create a new test issue:
```
Title: GitHub Actions test
Body: Testing autonomous resolution via GitHub Actions
```

The workflow will:
1. Detect new issue automatically (via webhook)
2. Run diagnostics
3. Post report
4. Close if healthy

**Note**: Auto-trigger requires webhook setup (Step 4 below)

---

## Automatic Triggering (Optional)

To make it **fully automatic** on new issues:

### Option A: Repository Webhook (Recommended)

1. Go to: `https://github.com/VelocityFibre/ticketing/settings/hooks`
2. Click "Add webhook"
3. Configure:
   - **Payload URL**: `https://api.github.com/repos/VelocityFibre/ticketing/dispatches`
   - **Content type**: `application/json`
   - **Secret**: (leave blank for now)
   - **Events**: Select "Issues" only
   - **Active**: ✓ Checked
4. Save

Then update workflow trigger:
```yaml
on:
  issues:
    types: [opened]  # ← Auto-trigger on new issues
```

### Option B: External Service (Zapier, n8n, etc.)

If you want filtering (e.g., only QField-related issues):
- Use Zapier/n8n to listen for GitHub issues
- Filter by labels or keywords
- Trigger workflow via repository_dispatch

---

## Monitoring

### View Workflow Runs

`https://github.com/VelocityFibre/ticketing/actions`

Each run shows:
- ✅ Success/failure status
- ⏱️ Execution time
- 📋 Full logs
- 📦 Diagnostic artifacts (if failed)

### Check Costs (Should Always Be $0)

`https://github.com/organizations/VelocityFibre/settings/billing`

**Expected**: 0 minutes used (workflow too fast to meter) or <1 minute

---

## Troubleshooting

### Workflow Fails: "SSH Connection Timeout"

**Cause**: SSH key secret not set correctly

**Fix**:
```bash
# Verify SSH key format
cat ~/.ssh/qfield_vps | head -1
# Should show: -----BEGIN OPENSSH PRIVATE KEY-----

# Re-add secret with exact content (including BEGIN/END lines)
```

### Workflow Fails: "GitHub Token Permission Denied"

**Cause**: Repository settings restrict Actions permissions

**Fix**:
1. Go to: `https://github.com/VelocityFibre/ticketing/settings/actions`
2. Under "Workflow permissions"
3. Select "Read and write permissions"
4. Save

### Workflow Doesn't Trigger Automatically

**Cause**: Webhook not configured or workflow trigger not set

**Fix**:
1. Check webhook exists (Settings → Webhooks)
2. Check workflow has `on: issues: types: [opened]`
3. Verify workflow is enabled (Actions tab)

### Diagnostics Fail: "Docker Command Not Found"

**Cause**: QFieldCloud VPS configuration changed

**Fix**:
```bash
# Test SSH manually from GitHub Actions:
# Add this step to workflow temporarily:
- name: Debug SSH
  run: |
    ssh -i ~/.ssh/qfield_vps root@72.61.166.168 "which docker"
```

---

## Cost Monitoring

### Expected Usage

| Metric | Value |
|--------|-------|
| Issues/month | 20 |
| Seconds/issue | 30 |
| Minutes/month | 10 |
| Free tier | 2,000 min |
| Cost | **$0** |

### Set Up Billing Alerts (Optional)

1. Go to: `https://github.com/organizations/VelocityFibre/settings/billing`
2. Set spending limit: $5/month (safety net)
3. Enable email alerts

**Reality**: You'll never hit this with support tickets.

---

## Rollback

If you need to disable:

### Temporary (Pause)

1. Go to: `https://github.com/VelocityFibre/ticketing/actions`
2. Click "Autonomous QField Support"
3. Click "..." menu → "Disable workflow"

### Permanent (Remove)

```bash
git rm .github/workflows/autonomous-support.yml
git commit -m "Remove autonomous support workflow"
git push
```

---

## Extending

### Add More Issue Types

Edit `.github/workflows/autonomous-support.yml`:

```yaml
on:
  issues:
    types: [opened]
  # Add label-based triggering
  label:
    types: [created]
```

### Add Slack Notifications

Add step to workflow:
```yaml
- name: Notify Slack
  if: always()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "Issue #${{ github.event.issue.number }} resolved in 30s"
      }
```

### Add Email Notifications

GitHub Actions automatically emails on failure (no setup needed).

---

## Files Created

```
.github/
├── workflows/
│   ├── autonomous-support.yml          # Main workflow
│   ├── SETUP.md                         # This file
│   └── scripts/
│       └── auto_resolve.py              # Resolution script
```

---

## Next Steps After Setup

1. ✅ Push workflow to GitHub
2. ✅ Add secrets (ANTHROPIC_API_KEY, QFIELD_VPS_SSH_KEY)
3. ✅ Test manually with issue #6
4. ✅ Create new test issue
5. ✅ Monitor first 5 automatic resolutions
6. ⚠️ Adjust thresholds if needed
7. 🚀 Enable for all new issues

---

## Success Criteria

After setup, you should see:

- ✅ Manual workflow trigger works (issue #6)
- ✅ Automatic trigger on new issues
- ✅ Diagnostic reports posted to issues
- ✅ Issues auto-closed when healthy
- ✅ GitHub Actions usage: 0-10 minutes/month
- ✅ Cost: $0

**When all checkboxes pass**: System is fully autonomous 🎉

---

## Support

**Workflow not working?**
1. Check workflow runs: `https://github.com/VelocityFibre/ticketing/actions`
2. Review logs (click on failed run)
3. Check secrets are set correctly
4. Test SSH manually: `ssh -i ~/.ssh/qfield_vps root@72.61.166.168`

**Questions?**
- GitHub Actions docs: https://docs.github.com/en/actions
- Workflow syntax: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions
- This project docs: `docs/guides/AUTONOMOUS_GITHUB_TICKETING.md`
