# IDUH Org-Mode Static Site Generator

Publish your Org-Mode documents as blog posts, highly opinionated for blog post generation.
In experimental stage, and created for personal use. mostly vibe coded.

## Quick Start (with `use-package`)

```elisp
(use-package iduh-org-mode-ssg
  :straight (iduh-org-mode-ssg
             :type git
             :host github
             :repo "rmnull/iduh-org-mode-ssg")
  :commands (iduh-org-ssg-build-site
             iduh-org-ssg-generate-file
             iduh-org-mode-ssg-preview
             iduh-org-ssg-clean)
  :custom
  ;; 1. Where your source .org files are stored
  (iduh-org-ssg-posts-directory "~/blog/posts/")
  
  ;; 2. The skeleton containing templates/ and static/ assets
  (iduh-org-ssg-skeleton-directory "~/blog/skeleton/")
  
  ;; 3. The destination for your generated website
  (iduh-org-ssg-output-directory "~/blog/public/")
  
  :bind (("C-c o s b" . iduh-org-ssg-build-site)
         ("C-c o s c" . iduh-org-ssg-clean)))
```

---

### Supported Org Syntax

| Feature | Org Syntax | Notes |
| :--- | :--- | :--- |
| **Title** | `#+TITLE: My Title` | Mandatory. Sets page `<title>` and `h1`. |
| **Date** | `#+DATE: 2024-12-24` | Mandatory. Used for metadata and display. |
| **Subtitle** | `#+SUBTITLE: My Subtitle` | Optional. |
| **Metadata** | `#+AUTHOR: Name`, `#+DESCRIPTION: Text` | Optional. Used for meta tags. |
| **Headings** | `* Section Heading` | **Single-level only**. Nested headings error. |
| **Images** | `[[./src.png][Alt Text]]` | **Alt text is mandatory**. |
| **Quotes** | `#+BEGIN_QUOTE` ... `#+END_QUOTE` | Standard Org quoting. |
| **Formatting** | `*bold*`, `/italic/`, `_underline_`, `+strike+` | Standard inline formatting. |

> [!IMPORTANT]
> **Key Constraints:**
> - **Mandatory Fields:** Every file must have `#+TITLE` and `#+DATE`.
> - **Flat Hierarchy:** Only single-asterisk `*` headings are supported.
> - **Descriptive Images:** All images must include alt text: `[[path][description]]`.


---

## Configuration

### Required Configuration Variables

You typically only set **three variables**:

| Variable                        | Default       | Description |
|---------------------------------|---------------|-------------|
| `iduh-org-ssg-posts-directory`    | `"posts/"`    | Directory containing your source `.org` files |
| `iduh-org-ssg-skeleton-directory` | `"skeleton/"` | Directory containing `templates/` + `static/` |
| `iduh-org-ssg-output-directory`   | `"public/"`   | Output directory for generated HTML |

### Example Configuration (config.el)

```elisp
;; Load the SSG package
(require 'iduh-org-mode-ssg)

;; Configure the skeleton + output
(setq iduh-org-ssg-skeleton-directory "~/blog/skeleton/")
(setq iduh-org-ssg-output-directory "~/blog/public/")

;; Generate the site
(iduh-org-ssg-build-site :base "~/blog/")

;; If your notes are not in ~/blog/posts/, provide :posts:
;; (iduh-org-ssg-build-site :base "~/blog/" :posts "content/")
```

### Skeleton Verification

You can validate a skeleton directory before building:

```elisp
(iduh-org-ssg-verify-skeleton "~/blog/skeleton/")
;; or interactively:
;; M-x iduh-org-ssg-verify-skeleton
```

---



## Features

- **Simple Org-Mode syntax** – titles, subtitles, sections, paragraphs, blockquotes, images
- **Inline formatting** – bold, italic, underline, strikethrough
- **Beautiful default styling** – responsive, dark mode support, Google Fonts
- **Batch processing** – generate an entire site from a directory of org files
- **Customizable templates** – optional header/footer templates
- **Static file handling** – CSS and assets are properly linked for HTTP serving

---

## Directory Structure

```
your-project/
├── posts/                          # Source org files (notes)
│   ├── my-first-post.org
│   ├── another-article.org
│   └── assets/                     # Post-specific images/media
│       └── example-image.png
│
├── skeleton/                       # Site skeleton (templates + static)
│   ├── templates/
│   │   ├── base.html               # Base HTML wrapper
│   │   ├── header.html             # Site header/navigation
│   │   └── footer.html             # Site footer
│   └── static/
│       ├── css/
│       │   └── style.css           # Main stylesheet
│       └── asset/
│           └── site-logo.svg       # Used by the default header template
│
├── public/                         # Generated output (configurable)
│   ├── my-first-post.html         # Generated from posts/my-first-post.org
│   ├── another-article.html       # Generated from posts/another-article.org
│   ├── css/
│   │   └── style.css              # Copied from skeleton/static/
│   └── asset/
│       └── site-logo.svg          # Copied from skeleton/static/
│
└── config.el                       # Site configuration (optional)
```

---



## Template System

For a comprehensive guide on creating custom themes, see the [Skeleton/Theming Guide](./SKELETON_GUIDE.md).

Templates are HTML files in your skeleton (`skeleton/templates/`) that wrap around
your generated content.

### Header Template (`skeleton/templates/header.html`)

```html
<header class="site-header">
  <nav>
    <a href="/" class="logo">My Blog</a>
    <ul>
      <li><a href="/about.html">About</a></li>
      <li><a href="/archive.html">Archive</a></li>
    </ul>
  </nav>
</header>
```

### Footer Template (`skeleton/templates/footer.html`)

```html
<footer class="site-footer">
  <p>&copy; 2024 My Blog. All rights reserved.</p>
</footer>
```

### Template Variables

Templates can include placeholders that get replaced during generation:

| Placeholder         | Description                        |
|---------------------|------------------------------------|
| `{{title}}`         | Post title from `#+TITLE`          |
| `{{date}}`          | Publication date from `#+DATE`     |
| `{{author}}`        | Author from `#+AUTHOR`             |
| `{{year}}`          | Current year                       |

---

## Generated HTML Structure

Each org file generates an HTML file with this structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Post Title</title>
  <meta name="generator" content="iduh-org-mode-ssg">
  <meta name="date" content="2024-12-24">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <!-- Optional: Header template content -->
  
  <article>
    <header>
      <h1 class="title">Post Title</h1>
      <p class="subtitle">Optional subtitle</p>
      <time class="published-date" datetime="2024-12-24">December 24, 2024</time>
    </header>
    
    <section>
      <h2>Section Heading</h2>
      <p>Content...</p>
    </section>
  </article>
  
  <!-- Optional: Footer template content -->
</body>
</html>
```

---

## Usage

### Single File Generation

```elisp
;; Generate a single org file to HTML
(iduh-org-ssg-generate-file "posts/my-post.org" "public/")

;; If you want to point at a skeleton explicitly:
;; (iduh-org-ssg-generate-file "posts/my-post.org" "public/" :skeleton "~/blog/skeleton/")
```

### Batch Site Generation

```elisp
;; Generate all org files in posts/ to public/
(iduh-org-ssg-build-site :base "~/your-project/")

;; Or with custom directories
(iduh-org-ssg-build-site 
  :base "~/your-project/"
  :posts "content/"
  :output "dist/")
```

### Interactive Commands

- `M-x iduh-org-ssg-build-site` – Build the entire site
- `M-x iduh-org-ssg-generate-file` – Generate a single file
- `M-x iduh-org-ssg-preview` – Preview current org file in browser
- `M-x iduh-org-ssg-clean` – Remove all generated files in output directory

---

## Serving the Site

The `public/` directory is designed to be served by any static HTTP server:

### Using Emacs (simple-httpd)

```elisp
(require 'simple-httpd)
(setq httpd-root "~/your-project/public/")
(httpd-start)
;; Site available at http://localhost:8080
```


### Using Python

```bash
cd public/
python -m http.server 8000
```

---

## Filename Convention

Generated HTML files are named based on the org file's `#+TITLE`:

| Org File               | #+TITLE              | Generated HTML          |
|------------------------|----------------------|-------------------------|
| `my-post.org`          | `My First Post`      | `my-first-post.html`    |
| `2024-recap.org`       | `Year in Review`     | `year-in-review.html`   |
| `intro.org`            | `Getting Started`    | `getting-started.html`  |

The title is:
1. Converted to lowercase
2. Spaces replaced with hyphens
3. Special characters removed
4. `.html` extension added

---

## Error Handling

The SSG provides clear error messages for common issues:

| Error                    | Cause                                    | Solution                              |
|--------------------------|------------------------------------------|---------------------------------------|
| `Missing #+DATE`         | Org file has no `#+DATE` field           | Add `#+DATE: YYYY-MM-DD` to the file |
| `Sub-heading not allowed`| Used `** Heading` instead of `* Heading` | Use single-level headings only       |
| `Image without alt text` | `[[image.png]]` without description      | Use `[[image.png][Alt text]]`        |
| `Unclosed quote block`   | Missing `#+END_QUOTE`                    | Close your `#+BEGIN_QUOTE` blocks    |

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
