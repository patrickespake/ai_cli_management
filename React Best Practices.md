
# React Best Practices

A practical, opinionated guide for building **robust, maintainable and accessible** React applications in production.

> These recommendations are based on the experience of several large-scale projects (web, mobile & desktop) and align with the React, ESLint-React, and React-Native documentation.  
> They are not hard rules—always apply engineering judgment in your context.

---

## 1. Project & File Organisation

1. **Component Driven Development**  
   Group files by _feature_ or _domain_ (not by type). A typical structure:
   ```text
   src/
   ├── features/
   │   └── invoice/
   │       ├── InvoicePage.tsx
   │       ├── InvoiceForm.tsx
   │       ├── hooks.ts
   │       ├── invoice.slice.ts
   │       └── styles.module.css
   ├── shared/   # Reusable UI primitives (Button, Modal, …)
   └── app.tsx
   ```
2. **One component per file** and keep files under ≈200 lines.  
   If a component grows larger, split out hooks, helpers or sub-components.
3. **Use TypeScript** (or PropTypes) everywhere. It documents the contract and eliminates a whole class of runtime errors.

---

## 2. Components

1. **Prefer function components** + hooks. Class components are still supported but add cognitive overhead.
2. **Top-level declarations first** (`prop` types, `defaultProps`, `consts`, then component, then helpers).
3. **Destructure props early** for readability:
   ```tsx
   function Avatar({ src, alt, size = 32 }: AvatarProps) { /* … */ }
   ```
4. **No anonymous default exports**. Name every component (better stack traces & grep).
5. **Avoid prop drilling**—lift state or use context/state libraries when 3+ levels deep.
6. **Memoise sparingly** (`React.memo`, `useMemo`, `useCallback`). Profile first; premature memoisation can hurt more than help.
7. **Composable API design**: favour small focused components that compose rather than giant “Swiss-army knife” components.
8. **Accessibility (a11y)** built-in: correct semantic elements (`<button>`, `<nav>`), keyboard interactions, ARIA labels.

---

## 3. State Management

1. **Local first**: keep state as close as possible to where it is used (often component-level with `useState`).
2. **Derived state**: compute on the fly with selectors rather than store duplicates.
3. **Global state** only when necessary (e.g. authentication, theme). Options:
   • React Context (light)  
   • Zustand, Jotai (simple + minimal boilerplate)  
   • Redux Toolkit, Recoil, MobX (complex domain data)
4. **Immutable updates**. Prefer Immer (built-in in RTK) or spread syntax.
5. **Server state is not client state**. Use a dedicated tool for async data (React Query, SWR, Apollo). Cache, automatic retries and background sync are solved problems.

---

## 4. Side Effects & Data Fetching

1. **`useEffect` ≠ lifecycle**: treat it as _synchronisation_ between React and the outside world.
2. Keep effects minimal and **declare every dependency** (lint rule `react-hooks/exhaustive-deps`).
3. **Abortable fetches** with `AbortController` to avoid race conditions on fast navigation.
4. Extract data-fetching into custom hooks (`useInvoices()`) for reuse & testability.
5. Show loading & error states: skeletons/spinners and toasts/alerts (never silent failures).

---

## 5. Performance

1. **Avoid unnecessary renders**: key culprit is _referential inequality_. Memoise callbacks passed to deep trees.
2. **List virtualisation** for long lists (`react-window`, `react-virtualized`).
3. **Code-splitting** (`React.lazy` + `Suspense`, dynamic `import()` for routes/components).  
   Pre-fetch on hover or when link is in viewport for perceived speed.
4. **Image optimisation**: use correct sizes, `loading="lazy"`, modern formats (WebP, AVIF).
5. **Bundle analysis**: run `webpack-bundle-analyzer`/`vite --report` regularly.

---

## 6. Styling

1. **CSS-in-JS vs CSS Modules vs Tailwind**—pick one, stay consistent.
2. **Scoped styles** (`.module.css` or CSS-in-JS) prevent cascade leakage.
3. **Utility classes** (Tailwind, UnoCSS) speed up development, but document design tokens.
4. **No magic numbers**. Use variables for spacing, colours, fonts—drives theming & dark mode.

---

## 7. Error Handling & Logging

1. Wrap root with **Error Boundaries** to catch rendering errors (`@sentry/react` provides one).
2. Graceful degradation: show friendly fallback UI, keep user productive.
3. Centralise logging/monitoring (Sentry, LogRocket, Datadog RUM) in production.

---

## 8. Testing

1. **Testing Pyramid**: majority in _unit_ (Jest + React Testing Library), some _integration_, few _E2E_ (Cypress, Playwright).
2. **Test behaviour not internals**: query by role/text not by class names/ids.
3. Mock network requests, not components (keep tests close to reality).
4. 100% coverage is not the goal—measure _impact_.

---

## 9. Tooling & Automation

1. **ESLint + Prettier** (or Biome/Rome) to enforce style; run on pre-commit via Husky.
2. **Type-checking** in CI: `tsc --noEmit` or `vite build --mode=types`.
3. **Absolute imports** (`@/shared/Button`) via `tsconfig.paths` to avoid `../../../` hell.
4. **Commit lint** + Conventional Commits for predictable changelogs.
5. **Continuous Integration**: lint, type-check, test, build; block PR if any step fails.

---

## 10. Security

1. **`dangerouslySetInnerHTML` only when sanitised** (DOMPurify).
2. Store secrets in **environment variables**, never in repo.
3. Keep dependencies updated; enable Dependabot/Snyk.
4. Use **Content Security Policy** headers to mitigate XSS.

---

## 11. Accessibility Checklist (WCAG AA)

- Semantic HTML elements (nav, main, header, footer, section)
- Labels for every form control
- Focus indicators visible, logical tab order
- ARIA live regions for dynamic content
- Colour contrast ≥ 4.5:1 (text) / 3:1 (large text)
- Keyboard & screen-reader friendly components (menus, dialogs, modals)

---

## 12. Documentation & Communication

1. Keep component README or JSDoc for public API & examples.
2. Storybook (or Ladle, Histoire) as living documentation.
3. Record design decisions (ADR) in `/docs/adr/`.
4. PR templates: what + why + screenshots + testing steps.

---

## 13. Migration Path & Legacy Code

1. Introduce TypeScript gradually (`// @ts-nocheck` only as last resort).
2. Wrap legacy class components in functional “container” while refactoring.
3. Migrate state management separate from UI changes.

---

## 14. Useful References

- React Official Documentation (react.dev)
- React Hooks FAQ (react.dev)
- Kent C. Dodds® EpicReact.dev & TestingJavaScript.com
- React Performance Cheat Sheet — google “react-perf-devtools”
- WAI-ARIA Authoring Practices 1.2

---

### Remember: **Make it work → make it correct → make it fast** — in that order.

Happy coding! 🎉
