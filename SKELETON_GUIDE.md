# Skeleton/Theming Guide

A **Skeleton** in `iduh-org-mode-ssg` is a directory containing the templates and static assets that define the visual structure and style of your generated website. By creating a custom skeleton, you can completely change the theme of your site.

## Directory Structure

A valid skeleton must follow this specific directory layout:

```text
my-custom-skeleton/
├── templates/
│   ├── base.html       (Required: Main HTML wrapper)
│   ├── header.html     (Required: Site navigation/header)
│   └── footer.html     (Required: Site footer)
└── static/
    ├── css/
    │   └── style.css   (Required: Primary stylesheet)
    └── asset/
        └── site-logo.svg (Required: Site logo)
```

> **Note:** You can add additional files to the `static/` directory (e.g., more CSS files, JavaScript, or images), and they will be copied verbatim to the output directory during the build process.

---

## Required Templates

### 1. `base.html`
This is the skeleton of every page. It defines the `<head>` and the overall structure of the `<body>`.

**Available Placeholders:**
- `{{lang}}`: The language code (e.g., `en`).
- `{{title}}`: The plain-text title of the document.
- `{{meta}}`: Automatically generated meta tags for date and description.
- `{{google_fonts_url}}`: The URL for Google Fonts configured in Emacs.
- `{{css_path}}`: The relative path to the stylesheet (defaults to `css/style.css`).
- `{{header}}`: The processed content of your `header.html`.
- `{{formatted_title}}`: The HTML-rendered title.
- `{{formatted_subtitle}}`: The HTML-rendered subtitle (if present).
- `{{formatted_date}}`: The formatted "Published on..." date string.
- `{{content}}`: The main content of the Org document, converted to HTML.
- `{{footer}}`: The processed content of your `footer.html`.

### 2. `header.html` & `footer.html`
These are partial templates included in `base.html` via the `{{header}}` and `{{footer}}` placeholders.

**Available Placeholders:**
- `{{title}}`: Page title.
- `{{date}}`: Raw date string.
- `{{author}}`: Document author (from `#+AUTHOR`).
- `{{logo_path}}`: Relative path to the site logo (defaults to `asset/site-logo.svg`).
- `{{year}}`: The current year (useful for copyright notices).

---

## Static Assets

The `static/` directory contains files that are copied directly to your site's root. For example:
- `static/css/style.css` becomes `public/css/style.css`.
- `static/favicon.ico` becomes `public/favicon.ico`.
- `static/js/main.js` becomes `public/js/main.js`.

The SSG expects at least `css/style.css` and `asset/site-logo.svg` to be present for the default configuration to work correctly.

---

## Using Your Custom Skeleton

### Method 1: Global Configuration
Set the `iduh-org-ssg-skeleton-directory` variable in your Emacs configuration:

```elisp
(setq iduh-org-ssg-skeleton-directory "~/path/to/my-custom-skeleton/")
```

### Method 2: Build Argument
Pass the skeleton directory directly to the build function:

```elisp
(iduh-org-ssg-build-site :skeleton "~/path/to/my-custom-skeleton/")
```

---

## Verification

You can verify if your skeleton directory is correctly structured by running the following command in Emacs:

`M-x iduh-org-ssg-verify-skeleton`

Then select your skeleton directory. It will report any missing files or directories.
