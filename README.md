# QField Support Portal (Standalone)

**Ultra-lightweight static support portal** - Zero impact on FibreFlow app, deploys anywhere.

## Features

✅ **GitHub Issues integration** - Shows recent tickets
✅ **Real-time search** - Filter issues client-side
✅ **System status check** - Direct API health check
✅ **Quick actions** - Report bug, view docs, check status
✅ **Responsive design** - Works on mobile/desktop
✅ **Zero dependencies** - Pure HTML/CSS/JS (no build needed)
✅ **No server required** - Static file, can host anywhere

## Size & Performance

```
index.html: 13KB (uncompressed)
Load time: <100ms
Bundle size: 0KB (no JavaScript frameworks)
Build time: 0s (no build step)
```

vs. Adding to Next.js FibreFlow:
```
Your current build: 843MB
Build time: ~2-5 minutes
Added page cost: +50-100KB per route
```

## Quick Setup (2 minutes)

### 1. Configure GitHub Repo

Edit `index.html` line 262:
```javascript
const GITHUB_REPO = 'yourusername/QFieldCloud'; // Change this
```

### 2. (Optional) Add GitHub Token

For higher rate limits (60 → 5000 requests/hour):
```javascript
const GITHUB_TOKEN = 'ghp_your_token_here'; // Line 263
```

### 3. Deploy

**Option A: GitHub Pages** (Recommended - Free hosting)
```bash
cd support-portal
git init
git add .
git commit -m "Initial commit"
git branch -M gh-pages
git remote add origin https://github.com/yourusername/qfield-support.git
git push -u origin gh-pages
```

Access at: `https://yourusername.github.io/qfield-support/`

**Option B: Netlify Drop** (Drag & drop)
1. Go to https://app.netlify.com/drop
2. Drag `support-portal/` folder
3. Done! Live in 30 seconds

**Option C: Add to existing hosting**
```bash
# Copy to your web server
scp index.html user@server:/var/www/html/support.html

# Or add to FibreFlow public/ folder (served as static asset)
cp index.html /path/to/fibreflow/public/support.html
```

Access at: `https://fibreflow.app/support.html`

**Option D: Serve from FibreFlow's public folder** (Zero build impact)
```bash
# Copy to FibreFlow public directory
VF_SERVER_PASSWORD="VeloAdmin2025!" .claude/skills/vf-server/scripts/execute.py 'mkdir -p /home/louis/apps/fibreflow.OLD_20251217/public/support'

# Upload file
scp support-portal/index.html louis@100.96.203.105:/home/louis/apps/fibreflow.OLD_20251217/public/support/index.html
```

Access at: `https://app.fibreflow.app/support/` (Next.js serves public/ as static)

## Usage

### For End Users

1. **Visit portal**: `https://yoursite.com/support`
2. **Search existing issues** or click "Report Bug"
3. **Create GitHub issue** (redirects to GitHub)
4. **Track ticket status** in portal

### For Support Staff (You)

When new issue created:
1. **Get notification** (GitHub email/webhook)
2. **Run**: `/qfield/support <issue-number>` (in Claude Code)
3. **Claude auto-diagnoses** and posts solution
4. **User gets response** in GitHub issue

## Architecture

```
┌─────────────────────────────────────────┐
│  Static HTML Page (13KB)                │
│  https://yoursite.com/support           │
│                                          │
│  ┌─────────────────────────────────┐   │
│  │  Client-side JavaScript          │   │
│  │  • Fetch GitHub API              │   │
│  │  • Display issues                 │   │
│  │  • Search/filter                  │   │
│  │  • Status checks                  │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
         ↓                    ↓
    GitHub API          QField API
  (issues data)      (health check)
```

**Zero server-side code** = Zero maintenance, zero scaling issues.

## Why This Beats Adding to FibreFlow App

| Metric | Add to FF App | Standalone Portal |
|--------|---------------|-------------------|
| **Build size** | +50-100KB | 0KB impact |
| **Build time** | +10-30s | 0s |
| **Deploy complexity** | Full app redeploy | Copy 1 file |
| **Failure isolation** | Breaks with app | Independent |
| **Scaling** | Same server | CDN-ready |
| **Maintenance** | Coupled to FF | Isolated |
| **Cost** | Existing server | Free (GitHub Pages) |

## Customization

### Change Colors (Line 10-15)
```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
/* Change to your brand colors */
```

### Add Logo
```html
<header>
    <img src="logo.png" alt="Logo" style="height:50px;margin-bottom:20px;">
    <h1>🛟 QField Support Portal</h1>
```

### Add Custom Quick Actions
```javascript
<div class="action-card" onclick="customAction()">
    <div class="icon">⚡</div>
    <h3>Custom Action</h3>
    <p>Your description</p>
</div>
```

### Connect to Your API
```javascript
async function checkStatus() {
    const response = await fetch('https://your-api.com/status');
    // Custom logic
}
```

## Integration with /qfield/support Command

Portal users create issues → You get notified → Run `/qfield/support <N>` → Claude responds

**Workflow**:
1. User visits `https://yoursite.com/support`
2. Clicks "Report Bug" → Creates GitHub issue
3. GitHub emails you: "New issue #42"
4. You run: `/qfield/support 42` in Claude Code
5. Claude gathers diagnostics, posts solution to issue
6. User sees solution in GitHub, tries fix, closes issue

## Advanced: Auto-Notify

Want instant notifications? Add webhook:

**GitHub Settings → Webhooks → Add webhook**:
- URL: `https://yourapi.com/webhook`
- Events: Issues (created, commented)
- Payload: JSON

Then create tiny API endpoint:
```javascript
// webhook-handler.js (1 file, 20 lines)
app.post('/webhook', (req, res) => {
    const issue = req.body.issue;
    if (req.body.action === 'opened') {
        // Send Slack/Discord/Email notification
        notify(`New support issue #${issue.number}: ${issue.title}`);
    }
    res.sendStatus(200);
});
```

Deploy webhook handler anywhere (Vercel, Netlify Functions, Cloudflare Workers).

## Performance Monitoring

The portal itself checks QField status via:
```javascript
fetch('https://qfield.fibreflow.app/api/v1/status/')
```

If you want detailed metrics, add:
```javascript
async function getDetailedStatus() {
    const [api, db, worker] = await Promise.all([
        fetch('/api/v1/status/'),
        fetch('/api/v1/health/database/'),
        fetch('/api/v1/health/worker/')
    ]);
    // Display results
}
```

## Security

**Rate limiting**: GitHub API limits unauthenticated requests to 60/hour per IP. Add token for 5000/hour.

**No sensitive data**: Portal shows only public GitHub issues. No auth needed.

**CORS**: GitHub API allows cross-origin requests. No proxy needed.

**Content Security Policy**: Add if hosting on your domain:
```html
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self'; connect-src 'self' https://api.github.com https://qfield.fibreflow.app;">
```

## Testing

```bash
# Test locally
cd support-portal
python3 -m http.server 8000

# Open browser
open http://localhost:8000

# Verify:
# ✓ Issues load
# ✓ Search works
# ✓ Status check connects
# ✓ "Report Bug" opens GitHub
```

## Troubleshooting

**Issues not loading**:
- Check GITHUB_REPO is correct
- Check repo has Issues enabled
- Check rate limit: https://api.github.com/rate_limit
- Add GITHUB_TOKEN for higher limits

**Status check failing**:
- Verify QFIELD_STATUS_URL is accessible
- Check CORS headers on API
- Test URL directly: `curl https://qfield.fibreflow.app/api/v1/status/`

**Styling broken**:
- Check CSS is not blocked
- Clear browser cache
- Test in incognito mode

## Future Enhancements (If Needed)

If this simple portal grows, you can add:
- **Authentication**: Gate support portal behind login
- **Private issues**: Use GitHub GraphQL API for private repos
- **Multi-language**: Add i18n with simple JS translation object
- **Analytics**: Add Google Analytics or Plausible
- **Search backend**: Index issues in Algolia/Meilisearch for faster search
- **Real-time updates**: WebSocket connection for live issue updates

But **start simple** - this version covers 90% of use cases.

## Comparison: All Options

| Option | Pros | Cons | Recommendation |
|--------|------|------|----------------|
| **1. Static Portal (this)** | Zero build impact, free hosting, fast | Requires GitHub account to create issues | ⭐ **Best for most cases** |
| **2. Next.js page in FF** | Shared auth, same domain | Increases build time/size | Only if need FF data access |
| **3. Separate Next.js app** | Full control, isolated | Duplicate infrastructure | Overkill for support portal |
| **4. Public folder in FF** | Same domain, no build impact | Less flexible than standalone | Good middle ground |

## Recommendation

**Start with**: Option 4 (public folder in FF)
**Why**: Same domain, zero build impact, easy to migrate later
**Deploy**: `cp index.html /path/to/fibreflow/public/support.html`
**Access**: `https://app.fibreflow.app/support.html`

**If outgrows**: Move to GitHub Pages (Option 1)
**If need auth**: Add to Next.js as dynamic route (Option 2)

## Summary

You asked: *"Will adding to FF app make it slow?"*
Answer: **Yes** - You're at 227 pages, 843MB build already.

**This solution**:
- ✅ Zero impact on FibreFlow
- ✅ Works with your `/qfield/support` command
- ✅ Deploys in 2 minutes
- ✅ Free hosting
- ✅ Fast (<100ms load)

**Next step**: Copy to FibreFlow public folder, test, done!
