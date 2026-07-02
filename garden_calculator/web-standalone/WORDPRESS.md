# Putting GrowVault on WordPress

You have two very different code bases in this project. Pick the path that
matches what you want to embed.

| What you want | Use | Effort |
|---------------|-----|--------|
| A calculator **inside a WordPress page** | `growvault.html` (this folder) | Minutes |
| The **full Flutter app** on its own page | `flutter build web` + iframe | Moderate |

> Important: a Flutter Web app is a compiled JavaScript/WASM bundle. It cannot
> be "converted" into native WordPress/PHP or a Gutenberg block. You embed it as
> a static bundle (iframe) or you use the self-contained `growvault.html`
> widget, which is plain HTML/CSS/JS and drops straight into WordPress. For most
> people the HTML widget is the right choice.

---

## Option A - Custom HTML block (easiest, recommended)

The widget in `growvault.html` is fully self-contained: all CSS and JavaScript
are inline, it uses no external files, and every style is scoped under
`#growvault` so it will not fight your theme.

1. Open `growvault.html` in a text editor.
2. Copy the block between the two comment markers:

   ```
   <!-- ===== GROWVAULT WIDGET (copy this whole block ...) ===== -->
   ...
   <!-- /GROWVAULT WIDGET ===== -->
   ```

   That block includes the widget markup **and** its `<style>` and `<script>`.
3. In WordPress, edit a page/post, add a **Custom HTML** block
   (Gutenberg: `+` -> "Custom HTML"), and paste the block.
4. Update/Publish. Preview the page - the calculator is live.

If your editor strips the `<script>`/`<style>` (some do), use Option B or the
WPCode plugin in Option D instead.

---

## Option B - Upload the file and iframe it

Best when you want the whole page, or your editor blocks inline scripts.

1. Upload `growvault.html` to your site. Either:
   - Media Library (WordPress may block `.html` uploads by default - allow it,
     or upload via FTP/cPanel to e.g. `/wp-content/uploads/growvault.html`), or
   - any static host (Netlify, Cloudflare Pages, GitHub Pages) and use that URL.
2. Add a Custom HTML block with:

   ```html
   <iframe
     src="https://your-site.com/wp-content/uploads/growvault.html"
     style="width:100%;height:1200px;border:0;overflow:hidden"
     loading="lazy"
     title="GrowVault Calculator"></iframe>
   ```

3. Adjust `height` to fit (the widget is tall on mobile).

---

## Option C - Shortcode via a child theme

Gives you a reusable `[growvault]` shortcode.

1. Put `growvault.html` in your child theme, e.g.
   `wp-content/themes/your-child-theme/growvault.html`.
2. Add to the child theme's `functions.php`:

   ```php
   function growvault_shortcode() {
       $path = get_stylesheet_directory() . '/growvault.html';
       if ( ! file_exists( $path ) ) {
           return '<p>GrowVault file not found.</p>';
       }
       return file_get_contents( $path );
   }
   add_shortcode( 'growvault', 'growvault_shortcode' );
   ```

3. Drop `[growvault]` into any page or post.

Note: `file_get_contents` returns the whole HTML document. For a cleaner embed,
save just the widget block (markup + style + script, without
`<!doctype>/<html>/<head>/<body>`) to the file you load.

---

## Option D - A code plugin (no theme editing)

If you would rather not touch theme files:

- Install **WPCode** (formerly Insert Headers and Footers) or **Code Embed**.
- Create a new HTML snippet, paste the widget block from Option A, and insert it
  into the page with that plugin's block or shortcode.

These plugins are built to preserve `<script>` tags that the default editor may
strip.

---

## Option E - Embed the full Flutter app

Only if you specifically want the multi-page Flutter dashboard (home, database,
pet estimator, guide, about) rather than the single-file widget.

1. Build it:

   ```bash
   cd garden_calculator
   flutter pub get
   flutter build web --release --base-href /growvault/
   ```

2. Upload the entire `build/web/` folder to your server at, for example,
   `/wp-content/uploads/growvault/` (keep the folder structure intact).
3. Embed with an iframe pointing at `.../growvault/index.html`, sized generously:

   ```html
   <iframe src="/wp-content/uploads/growvault/index.html"
     style="width:100%;height:900px;border:0" title="GrowVault"></iframe>
   ```

Trade-offs: a Flutter Web bundle is a few MB and boots a canvas renderer, so it
is heavier than the HTML widget and less SEO-friendly. Use it only when you need
the full app experience.

---

## Which should I pick?

- Want it done in five minutes, light, and SEO-friendly: **Option A**.
- Editor strips scripts, or you want isolation: **Option B**.
- Want a reusable shortcut across many pages: **Option C** or **D**.
- Need the whole Flutter dashboard: **Option E**.
