# Medical Laboratory Website – BloodTestLab

This repository contains the code for **BloodTestLab**, the public-facing website of a medical laboratory that specialises in advanced blood tests and diagnostics.

## Project Goal

Provide patients, doctors and partners with a modern, accessible web experience that allows them to:

* Learn about the laboratory, its certifications and quality standards.
* Browse the catalogue of available blood tests and understand their clinical relevance.
* Book appointments or request home-collection services.
* Retrieve results securely (feature planned).

## Tech Stack

* **React** – SPA frontend framework.
* **TypeScript** – type-safe JavaScript for larger codebases.
* **Vite** – instant dev server & build tooling.
* **Tailwind CSS** – utility-first styling (subject to change).

The project currently contains only the frontend; backend/API integration will be added later.

## Getting Started

```bash
# install dependencies
pnpm install        # or yarn / npm install

# start development server
pnpm dev            # vite will serve at http://localhost:5173

# production build
pnpm build
```

## Folder Structure

```
sample-project/
├─ src/                 react source files (components, pages …)
├─ public/              static assets served as-is
└─ ...
```

## Contributing

Pull requests are welcome! Please open an issue first to discuss changes.

## License

Distributed under the MIT License. See `LICENSE` for more information (to be added).
