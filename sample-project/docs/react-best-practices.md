# React Best Practices

This document collects opinionated, experience-based guidelines for building **maintainable, accessible, and high-performance React applications**.  
Use it as a checklist when starting a new feature or during code-review.

---

## 1. Project Structure

- **Group by feature, not by type.**  
  `src/feature/Order/OrderPage.tsx`, `OrderContext.tsx`, `order.api.ts`, `order.test.tsx` keep related files together and ease deletion/refactor.
- **Keep components small** (≤200 LOC is a good heuristic). Prefer _composition over conditionals_ – break large renders into sub-components.
- **Use a `components/` or `ui/` folder only for truly shared, generic pieces** (e.g., `Button`, `Modal`). Everything else belongs to its feature folder.

## 2. Components

1. Prefer **function components with hooks** – class components exist only for legacy code.
2. Always start the file with the **public interface** (the `props` type) and export statement; put helpers below.
3. **Destructure props** in the parameter list to declare required vs optional values clearly.

```tsx
// Good
export function Avatar({ src, alt = 'User avatar', size = 48 }: AvatarProps) {
  // …
}
```

4. Mark components as **`memo`** only when measurements prove re-rendering is a bottleneck. Premature memoization adds complexity.

## 3. State Management

1. **Local first.** Use `useState` or `useReducer` inside the component that owns the data.
2. **Lift state up** one level at a time; avoid passing props through 3+ levels → create a **React Context** or adopt a library (`Zustand`, `Redux Toolkit`, `Recoil`).
3. Keep **server state** separate from UI state. Libraries like **React Query / TanStack Query** or **SWR** give caching, deduplication and background updates for free.

## 4. Side Effects

- Treat `useEffect` like `componentDidMount` **only when necessary**. 80 % of the time, rendering should be pure.
- Always declare all external dependencies in the effect’s dependency array; eslint-plugin-react-hooks will warn you.
- **Cleanup** subscriptions, timers, event listeners in the return function to avoid leaks.

## 5. Performance Optimization

| Technique | When to use |
|-----------|------------|
| `React.memo`, `useMemo`, `useCallback` | Expensive calculations or props triggering needless renders |
| **Code-splitting** (`React.lazy`, dynamic `import()`) | Routes, heavy libraries, WYSIWYG editors |
| **List virtualization** (`react-window`, `react-virtualized`) | Lists > 100 rows |
| **Image optimization** | Next-gen formats (AVIF/WebP), lazy loading |

Run **React Profiler** or **why-did-you-render** to confirm improvements.

## 6. Accessibility (a11y)

- Prefer **native HTML elements** over divs/spans (e.g., `button`, `label`).
- Set relevant **ARIA attributes** only when behavior cannot be expressed with semantics alone.
- Ensure **keyboard navigation**: `tabindex`, focus management, visually hidden labels.
- Validate with **axe-core**, Lighthouse or Storybook a11y addon on every PR.

## 7. Styling

1. Choose one approach and be consistent: **CSS Modules**, **CSS-in-JS (styled-components, Emotion)**, **utility frameworks (TailwindCSS)**.
2. Keep styles **co-located** with the component (`Button.module.css`, `Button.styled.ts`).
3. Prefer **className composition** instead of inline styles for better overrides and media queries.

## 8. Type Safety & Linting

- Use **TypeScript** – helps document the API and prevents many runtime bugs.
- Enable **`strict` mode** and no-implicit-any in `tsconfig.json`.
- Adopt **eslint + prettier** with `eslint-plugin-react`, `eslint-plugin-react-hooks`, and `@typescript-eslint` presets.

## 9. Testing

1. **React Testing Library** for unit/integration tests – test behavior, not implementation details.
2. **Jest** or **Vitest** as the test runner; keep each test <100 lines.
3. **Cypress** or **Playwright** for end-to-end flows (critical user journeys).
4. Aim for the **Testing Trophy**: prioritize unit business logic & integration over isolated snapshots.

## 10. Error Handling

- Wrap high-level routes in **Error Boundaries** to catch crashes and show fallback UIs.
- Log errors with **Sentry**, **Datadog** or similar services; include component stack.
- Provide **graceful degradation** for fetch errors: skeleton → error state → retry.

## 11. Data Fetching Patterns

1. **Declarative**: components describe what data they need; hooks/library handles when/how to fetch.
2. **Stale-While-Revalidate** (SWR) provides instant UI with background refresh.
3. **Pagination & infinite scroll** – request minimal slices, use cursors over page numbers.

## 12. Reusable/Custom Hooks

- Encapsulate non-UI logic (forms, websocket subscriptions) in **`useXyz`** hooks.
- Keep hooks **pure** – no DOM manipulation (use refs + effects instead).
- Return a clear API: `[state, actions]` or `{ data, mutate, isLoading }`.

## 13. Anti-Patterns to Avoid

❌ Mutating state directly (`state.list.push(item)`) – causes silent bugs.  
✅ Use the setter: `setList(prev => [...prev, item])`.

❌ Fetching data inside render or conditionally calling hooks.  
✅ Call hooks unconditionally at the top level.

❌ Deep prop drilling.  
✅ Provide data via context or colocate the component.

## 14. Tooling & CI

- **Husky + lint-staged** to run `eslint --fix` and tests before every commit.
- **Prettier** for consistent formatting; do not argue about style in review.
- Include **bundle analyzer** (`source-map-explorer`, `webpack-bundle-analyzer`) in CI to track bundle size regressions.

## 15. Documentation

- Maintain **Storybook** for reusable component catalog.
- Document complex hooks/components via JSDoc or MDX stories.

---

### Checklist Before Merging

1. [ ] No eslint/react warnings  
2. [ ] All tests pass, coverage unchanged  
3. [ ] Components follow accessibility guidelines  
4. [ ] Bundle size stable or justified  
5. [ ] PR description explains **why**, not only **what**  

Happy coding! 🚀
