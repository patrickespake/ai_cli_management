# Sample Medical Laboratory Website (React)

Welcome to the code-base for **MedLab – Blood Test Diagnostics**, a modern single-page web application that will serve as the public-facing website for a medical laboratory that specialises in blood analysis.

## Project Goals

1. Present the laboratory’s services (full blood count, lipid profile, hormone panels, etc.) in a clear and accessible manner.
2. Allow patients and healthcare providers to learn about test preparation, turnaround times and sample collection locations.
3. Provide an online portal entry-point (to be implemented later) where patients can retrieve their secure results.
4. Offer educational content that demystifies common blood tests and promotes preventive care.

## Tech Stack

• **React 18** – UI library used to build an interactive, component-driven front-end.  
• **Vite / Create React App** – Rapid development server and build tooling (to be decided).  
• **TypeScript** – Optional but recommended for type-safety and self-documentation.  
• **React Router** – Client-side routing for a seamless SPA experience.  
• **Styled Components / Tailwind CSS** – Styling solution (to be decided during early sprints).  
• **Jest + React Testing Library** – Unit and integration testing.  
• **ESLint + Prettier** – Code quality and formatting.

> Note: The back-end (authentication, report storage, etc.) is **out of scope for this repository** and will be addressed in a separate service.

## Getting Started (local dev)

```bash
# 1. Clone the repository and move into the project directory
git clone https://github.com/your-org/medlab-website.git
cd medlab-website/sample-project

# 2. Install dependencies
npm install # or pnpm install / yarn install

# 3. Start the development server
npm run dev   # vite
# or
npm start      # CRA

# 4. Open http://localhost:5173 (or 3000) in your browser
```

## Scripts

| Command           | Description                              |
| ----------------- | ---------------------------------------- |
| `npm start` / `npm run dev` | Launch the dev server with hot reloading |
| `npm run build`   | Production build                         |
| `npm test`        | Run unit tests                           |
| `npm run lint`    | Lint source code                         |

## Folder Layout (proposed)

```
sample-project/
│
├─ public/            # Static assets and HTML shell
├─ src/
│  ├─ assets/         # Images, icons, fonts
│  ├─ components/     # Re-usable presentational components
│  ├─ features/       # Feature-level slices (e.g. BookAppointment)
│  ├─ pages/          # Route-level components (Home, Services…)
│  ├─ hooks/          # Custom React hooks
│  ├─ utils/          # Helper functions
│  ├─ App.tsx        
│  └─ main.tsx / index.tsx
└─ README.md
```

## Contributing

1. Create an issue or pick one from the backlog.  
2. Create a feature branch: `git checkout -b feat/short-description`.  
3. Commit changes following Conventional Commits guidelines.  
4. Open a pull request – ensure that all checks pass before merging.

## License

This project is released under the MIT License.
