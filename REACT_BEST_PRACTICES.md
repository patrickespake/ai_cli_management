# React Best Practices - 2025

This document outlines the best practices for developing robust, scalable, and performant applications with React. These guidelines are based on current industry standards and the evolution of the React ecosystem.

## 1. Core Concepts

### Functional Components and Hooks

Functional components with Hooks are the standard for creating React components. They are more concise, easier to read, and promote better code reuse than class components.

- **Always use functional components.**
- **Embrace Hooks (`useState`, `useEffect`, `useContext`, etc.) for state and side effects.**
- **Create custom Hooks to encapsulate and reuse stateful logic.**

**Example (Custom Hook):**

```javascript
import { useState, useEffect } from 'react';

function useWindowWidth() {
  const [width, setWidth] = useState(window.innerWidth);

  useEffect(() => {
    const handleResize = () => setWidth(window.innerWidth);
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return width;
}
```

### Component Design Patterns

- **Keep Components Small and Focused:** Each component should have a single responsibility. If a component becomes too large or handles too many tasks, break it down into smaller, more manageable components.
- **Composition over Inheritance:** Build complex UIs by combining smaller, specialized components. This is more flexible and scalable than inheriting from a base component.
- **Container and Presentational Pattern:** Separate data-fetching and state management (container components) from UI rendering (presentational components). This improves reusability and separation of concerns.

### JSX Best Practices

- **Use parentheses for multi-line JSX.**
- **Use camelCase for HTML attributes (e.g., `className`, `onClick`).**
- **Use self-closing tags for components without children (`<MyComponent />`).**

## 2. State Management

### Local State

- **`useState`:** The primary hook for managing local component state. Keep state as close as possible to where it's used.
- **`useReducer`:** Use for more complex state logic, especially when the next state depends on the previous one or when multiple sub-values are involved.

### Global State

- **Context API:** Ideal for sharing data that can be considered "global" for a tree of React components, such as UI theme, authentication status, or language preference. Avoid using it for high-frequency updates.
- **Third-Party Libraries:** For complex, application-wide state, consider using a dedicated state management library:
    - **Redux Toolkit:** A robust and predictable solution for large-scale applications.
    - **Zustand / Jotai:** Lightweight and minimalistic alternatives to Redux.
- **Server-Side State (Data Fetching):**
    - **React Query (TanStack Query):** The de-facto standard for managing server state. It simplifies fetching, caching, synchronizing, and updating server data.

## 3. Props

### Prop Handling

- **Destructure Props:** Makes components cleaner and more readable.
- **Use TypeScript for Prop Types:** Provides static type checking, which catches bugs early and improves code documentation.
- **Default Props:** Use default function parameters for functional components to provide default values for props.

**Example (Props with TypeScript):**

```typescript
type GreetingProps = {
  name: string;
  message?: string;
};

function Greeting({ name, message = 'Hello' }: GreetingProps) {
  return (
    <div>
      {message}, {name}!
    </div>
  );
}
```

## 4. Conditional Rendering

- **Ternary Operator:** Use for simple conditional logic.
  ```javascript
  {isLoggedIn ? <UserProfile /> : <LoginForm />}
  ```
- **Logical `&&` Operator:** Use for rendering a component only if a condition is true.
  ```javascript
  {unreadMessages.length > 0 && <h2>You have {unreadMessages.length} unread messages.</h2>}
  ```
- **Return `null` or `<>`:** To render nothing, return `null` or an empty fragment.

## 5. Performance Optimization

- **`React.memo`:** A higher-order component that memoizes the rendered output of a component, preventing re-renders if the props haven't changed.
- **`useCallback`:** Memoizes functions, so they are not recreated on every render. This is important when passing callbacks to optimized child components.
- **`useMemo`:** Memoizes the result of a calculation, so it is not re-computed on every render.
- **Code Splitting with `React.lazy` and `Suspense`:** Split your code into smaller chunks that are loaded on demand. This improves initial load time.
- **Server-Side Rendering (SSR):** Use a framework like Next.js for SSR to improve performance and SEO.
- **Profiling:** Use the React DevTools Profiler to identify performance bottlenecks.

## 6. Error Handling

- **Error Boundaries:** Create a class component that implements `getDerivedStateFromError` or `componentDidCatch` to catch JavaScript errors anywhere in their child component tree, log those errors, and display a fallback UI.

## 7. Testing

- **Unit Testing:** Use a framework like **Jest** with **React Testing Library** to test individual components. Focus on testing component behavior from a user's perspective.
- **Integration Testing:** Test how multiple components work together.

## 8. Code Style and Structure

- **File and Folder Structure:** Organize files by feature or domain. This makes it easier to locate and manage related files in a large project.
  ```
  /src
  ├── /features
  │   ├── /authentication
  │   │   ├── components
  │   │   ├── hooks
  │   │   └── index.ts
  │   └── /profile
  │       ├── components
  │       ├── hooks
  │       └── index.ts
  ├── /components
  │   ├── /common
  │   └── /ui
  └── /lib
  ```
- **Linting:** Use **ESLint** to enforce code style and catch common errors.
- **Formatting:** Use **Prettier** to automatically format your code for a consistent style across the entire codebase.
