#!/bin/bash
# Auto-apply improvements to support portal
# Run from ticketing repo directory

set -e

echo "🚀 Applying improvements to index.html..."

# Backup
cp index.html index.html.pre-improvements

# 1. Add meta description after viewport
sed -i '/<meta name="viewport"/a\    <meta name="description" content="Get technical support for QFieldCloud synchronization, field data management, and GIS operations. Browse solutions, report issues, and track tickets.">\n\n    <!-- Open Graph -->\n    <meta property="og:type" content="website">\n    <meta property="og:title" content="QField Support Portal - FibreFlow">\n    <meta property="og:description" content="Technical support for QFieldCloud GIS synchronization and field operations">\n    <meta property="og:url" content="https://support.fibreflow.app/support.html">\n\n    <!-- Favicon -->\n    <link rel="icon" type="image/png" href="/icon.png">\n    <link rel="apple-touch-icon" href="/icon.png">' index.html

# 2. Update title
sed -i 's/<title>QField Support - FibreFlow<\/title>/<title>QField Support Portal - FibreFlow<\/title>/' index.html

# 3. Add role="navigation" to sidebar
sed -i 's/<aside class="sidebar">/<aside class="sidebar" role="navigation" aria-label="Main navigation">/' index.html

# 4. Add role="main" to main content
sed -i 's/<main class="main-content">/<main class="main-content" role="main" aria-label="Support dashboard content">/' index.html

# 5. Add aria-label to search input
sed -i 's/placeholder="Search tickets\.\.\."/placeholder="Search tickets..." aria-label="Search support tickets"/' index.html

# 6. Add keyboard shortcuts before closing </script> tag
sed -i '/<\/script>/i\
    // Keyboard shortcuts\
    document.addEventListener('"'"'keydown'"'"', (e) => {\
        // Ctrl/Cmd+K to focus search\
        if ((e.ctrlKey || e.metaKey) && e.key === '"'"'k'"'"') {\
            e.preventDefault();\
            document.getElementById('"'"'searchInput'"'"').focus();\
        }\
\
        // Esc to clear search\
        if (e.key === '"'"'Escape'"'"') {\
            const searchInput = document.getElementById('"'"'searchInput'"'"');\
            if (searchInput.value) {\
                searchInput.value = '"'"''"'"';\
                searchIssues();\
            }\
        }\
    });' index.html

# 7. Add Cloudflare Analytics placeholder before </body>
sed -i '/<\/body>/i\
    <!-- Cloudflare Web Analytics - Uncomment to enable -->\
    <!-- <script defer src='"'"'https://static.cloudflareinsights.com/beacon.min.js'"'"' data-cf-beacon='"'"'{"token": "YOUR_CLOUDFLARE_TOKEN"}'"'"'></script> -->' index.html

# 8. Add focus indicators to CSS (after existing focus styles)
sed -i '/\.search-box input:focus {/a\    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);' index.html

echo "✅ Improvements applied!"
echo ""
echo "Changes made:"
echo "  - Added meta description and Open Graph tags"
echo "  - Added ARIA labels for accessibility"
echo "  - Added role attributes for semantic regions"
echo "  - Added keyboard shortcuts (Ctrl+K for search, Esc to clear)"
echo "  - Improved focus indicators"
echo "  - Added Cloudflare Analytics placeholder"
echo ""
echo "File size before: $(wc -c < index.html.pre-improvements) bytes"
echo "File size after: $(wc -c < index.html) bytes"
echo ""
echo "Next steps:"
echo "1. Review changes: diff index.html.pre-improvements index.html"
echo "2. Test locally: python3 -m http.server 8000"
echo "3. Deploy: git add index.html && git commit && git push"
