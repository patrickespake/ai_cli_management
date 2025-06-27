# React Best Practices

> “Any application that can be written in JavaScript, will eventually be written in JavaScript.” – Jeff Atwood  
> And any JavaScript application that grows beyond a prototype will benefit from a consistent set of patterns.  

The following guidelines are a distilled, field-tested set of **best practices for building React applications** that remain **easy to reason about, easy to scale, and easy to maintain**. They are grouped into high-level topics so you can quickly reference the area that is most relevant to you at any moment during development.

---

## 1. Project & File Organisation

1. **Feature/Domain-based folders** instead of technology-based. Group `components`, `hooks`, `styles`, `tests`, etc. by feature.

   ```text
   src/
   ├── features/
   │   └── patient-dashboard/
   │       ├── PatientDashboard.tsx
   │       ├── usePatientData.ts
   │       ├── patientDashboard.module.css
   │       └── __tests__/PatientDashboard.test.tsx
   └── shared/
   ```

2. **Use an absolute import alias** (e.g. `@/`) to avoid `../../../..` paths.
3. **Keep files small** (≈ 200 lines max) and components focused on one responsibility.
4. **Name files after the default export**. Example: `PatientTable.tsx` exports `PatientTable`.

---

## 2. Component Design

1. **Prefer Function Components + Hooks** over class components unless you target very old browsers.
2. **Split into Container vs. Presentational (or “Smart vs. Dumb”) components** *only* when data fetching/business logic becomes non-trivial. Otherwise favour co-location.
3. **Keep component props minimal, explicit and typed** (TypeScript or PropTypes). Obey the “fewest possible props” rule.
4. **Use composition, not inheritance**. Leverage the `children` prop or render props / hooks.
5. **Be declarative** – describe “what” the UI should look like, not “how” to mutate it.
6. **Memoise judiciously** (`React.memo`, `useMemo`) – optimise last, measure first.

---

## 3. State Management

1. **Start with React local state + Context**. Reach for Redux/Zustand/Recoil only when *shared* or *server* state gets complex.
2. **Colocate state** where it is used most. “Lift state up” only when two distant components truly need it.
3. **Treat server data as *cache***, not local state. Libraries like React Query, SWR or TanStack Query avoid re-inventing fetch logic.
4. **Normalise complex collections** (entities by id) to prevent deeply nested objects.
5. **Keep derived data out of state**. Compute inside selectors/memoised getters.

---

## 4. Data Fetching

1. **Use Suspense-compatible libraries** (e.g. `fetch` wrapped in `react-query`) to prepare for concurrent features.
2. **Cancel stale requests** when components unmount (`AbortController` or cleanup in `useEffect`).
3. **Error boundaries** around data-heavy or third-party components prevent white screens.
4. **Incremental rendering**: show skeletons/placeholders, not spinners, to reduce layout shift.

---

## 5. Side Effects & `useEffect`

1. **Think in terms of “effects = synchronization”**. Effects sync React with an external system (DOM, API, event listener). If you don’t need sync, don’t use `useEffect`.
2. **Declare every value used inside an effect in its dependency array**, or explicitly justify why it is excluded with an ESLint comment.
3. **Cleanup** anything you set up (subscriptions, timers) in the return function.
4. **Avoid “fetch on mount” antipattern** – instead call inside an event handler or use a dedicated data library.

---

## 6. Styling

1. **CSS Modules, CSS-in-JS or Tailwind – be consistent**. Pick one primary styling strategy.
2. **Co-locate styles** with the component if using CSS-in-JS or Modules; otherwise use a clearly named global stylesheet.
3. **Use BEM or variant props** to avoid style clashes.
4. **Load critical CSS first** (code-split the rest via dynamic import or `React.lazy`).

---

## 7. Performance

1. **Code-split by route and by component** (`React.lazy`, `Suspense`).
2. **Avoid anonymous functions in JSX** where re-renders are frequent. Use `useCallback` *when it matters*.
3. **Virtualise large lists** (`react-window`, `react-virtualized`).
4. **Use the Production build** (`npm run build`) and enable gzip/brotli on the server.
5. **Monitor with React DevTools profiler**. Optimise hot paths only.

---

## 8. Accessibility (a11y)

1. **Use semantic HTML first** (`<button>`, `<nav>`, `<main>`...).
2. **All interactive elements need keyboard support** (`onKeyDown`, `tabIndex`).
3. **Add `aria-*` labels** where semantics are not enough.
4. **Colour contrast ratio** ≥ 4.5:1 (WCAG AA level).
5. **Test with screen readers** (NVDA, VoiceOver) and automated tools (axe, Lighthouse).

---

## 9. Testing

1. **Testing Pyramid** – most at unit level, some integration, a few e2e. Avoid snapshots except for visual diffing.
2. **React Testing Library** over Enzyme – test component behaviour, not implementation details.
3. **Mock external services**, not components you own.
4. **Strive for 100% critical-path coverage**, not 100% lines.

---

## 10. Tooling & Quality Gates

1. **TypeScript + `strict` mode** for catch-it-before-runtime safety.
2. **ESLint + `eslint-plugin-react-hooks` + Prettier** to enforce style and rules.
3. **Husky + lint-staged** to run tests/lint on pre-commit.
4. **Dependabot/renovate** for dependency updates.

---

## 11. Security

1. **Never trust the client** – validate data on the server.
2. **Sanitise dangerouslySetInnerHTML** (DOMPurify).
3. **Use HTTPS and secure cookies**; follow OWASP Top Ten.

---

## 12. Deployment

1. **Environment variables via `.env` files** (don’t commit secrets).
2. **Use CI/CD** (GitHub Actions, GitLab CI) with steps: lint → type-check → test → build → deploy.
3. **Bundler analysis** (`source-map-explorer`, `webpack-bundle-analyzer`) to keep bundle size low.

---

## 13. Keep Learning 🎓

React’s ecosystem evolves quickly. Follow the official blog, RFCs, and outstanding community resources like:

• React documentation (react.dev)  
• “Epic React” by Kent C. Dodds  
• “Overreacted” blog by Dan Abramov  
• The weekly React Newsletter

---

### Quick Checklist

- [ ] Components are functional & typed
- [ ] Side effects are inside `useEffect` with correct deps
- [ ] State is colocated & minimal
- [ ] Styling approach is consistent
- [ ] a11y checks pass
- [ ] Tests cover critical paths
- [ ] Lighthouse performance ≥ 90
- [ ] Bundle size monitored

> **Aim for clarity first, cleverness second.** Clean React code today means fewer headaches tomorrow.
