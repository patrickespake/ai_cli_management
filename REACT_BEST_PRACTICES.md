# React Best Practices

This document outlines the best practices for developing with React, aiming to create maintainable, scalable, and performant applications.

## Table of Contents

- [Component Design](#component-design)
- [State Management](#state-management)
- [Handling Side Effects](#handling-side-effects)
- [Code Organization](#code-organization)
- [Performance Optimization](#performance-optimization)
- [Testing](#testing)
- [Keys in Lists](#keys-in-lists)
- [Error Handling](#error-handling)
- [Accessibility (a11y)](#accessibility-a11y)

---

## Component Design

### 1. **Favor Functional Components and Hooks**
- **Why:** Functional components with hooks are the modern standard in React. They are more concise, easier to read and test, and promote a more functional style of programming.
- **Example:**
  ```jsx
  import React, { useState, useEffect } from 'react';

  function MyComponent({ prop }) {
    const [state, setState] = useState('');

    useEffect(() => {
      // Side effects go here
    }, [prop]);

    return <div>{prop}</div>;
  }
  ```

### 2. **Component Composition**
- **Why:** Build complex UIs by combining simple, reusable components. This follows the "Don't Repeat Yourself" (DRY) principle and makes your codebase easier to manage.
- **Example:** Instead of passing many props to configure a component, pass other components as `children`.
  ```jsx
  // Good
  function Dialog({ title, content }) {
    return (
      <div className="dialog">
        <h2 className="dialog-title">{title}</h2>
        <div className="dialog-content">{content}</div>
      </div>
    );
  }

  // Better with composition
  function Dialog({ title, children }) {
    return (
      <div className="dialog">
        <h2 className="dialog-title">{title}</h2>
        <div className="dialog-content">{children}</div>
      </div>
    );
  }

  // Usage
  <Dialog title="Welcome">
    <p>Thank you for visiting!</p>
  </Dialog>
  ```

### 3. **Keep Components Small and Focused**
- **Why:** Each component should have a single responsibility. This makes them easier to understand, test, and reuse. If a component becomes too large or complex, break it down into smaller components.

---

## State Management

### 1. **Use `useState` for Simple, Local State**
- **Why:** `useState` is perfect for managing state that is local to a single component, such as form inputs or toggle states.

### 2. **Use `useReducer` for Complex State Logic**
- **Why:** When you have complex state logic that involves multiple sub-values or when the next state depends on the previous one, `useReducer` can make your state updates more predictable and maintainable.
- **Example:**
  ```jsx
  const initialState = { count: 0 };

  function reducer(state, action) {
    switch (action.type) {
      case 'increment':
        return { count: state.count + 1 };
      case 'decrement':
        return { count: state.count - 1 };
      default:
        throw new Error();
    }
  }

  function Counter() {
    const [state, dispatch] = useReducer(reducer, initialState);
    // ...
  }
  ```

### 3. **Lift State Up When Necessary**
- **Why:** When multiple components need to share the same state, lift it up to their closest common ancestor. Avoid "prop drilling" (passing props through many levels) by using Context or a state management library for deeply nested data.

### 4. **Choose a State Management Library Wisely**
- **Why:** Libraries like Redux, Zustand, or MobX are powerful but add complexity. Only introduce them when you have a significant amount of global state that is accessed and updated by many components across your application. For simpler cases, `useState`, `useReducer`, and the Context API are often sufficient.

---

## Handling Side Effects

### 1. **Use `useEffect` for Side Effects**
- **Why:** `useEffect` is the standard hook for performing side effects like data fetching, subscriptions, or manual DOM manipulations.

### 2. **Master the Dependency Array**
- **Why:** The dependency array in `useEffect` is crucial for performance. It tells React when to re-run the effect.
  - **`[]` (empty array):** The effect runs only once after the initial render.
  - **`[dep1, dep2]`:** The effect runs on the initial render and whenever `dep1` or `dep2` changes.
  - **No array:** The effect runs after *every* render (use with caution).

### 3. **Clean Up Side Effects**
- **Why:** To prevent memory leaks, clean up side effects like subscriptions or timers in the return function of `useEffect`.
- **Example:**
  ```jsx
  useEffect(() => {
    const subscription = someApi.subscribe();
    return () => {
      subscription.unsubscribe();
    };
  }, []);
  ```

---

## Code Organization

### 1. **Structure Files by Feature or Component**
- **Why:** Grouping files related to a single feature or component (e.g., component, styles, tests) in the same folder makes the project easier to navigate and maintain.
- **Example Structure:**
  ```
  /src
  └── /components
      └── /Button
          ├── Button.js
          ├── Button.module.css
          └── Button.test.js
  ```

### 2. **Consistent Naming Conventions**
- **Components:** `PascalCase` (e.g., `MyComponent.js`)
- **Hooks:** `camelCase` with a `use` prefix (e.g., `useCustomHook.js`)
- **Variables/Functions:** `camelCase`

### 3. **CSS Strategy**
- **CSS Modules:** Scopes class names locally to the component, preventing style conflicts.
- **Styled-Components / Emotion (CSS-in-JS):** Co-locates styles with the component logic, enabling dynamic styling based on props.
- **Tailwind CSS:** A utility-first CSS framework that allows for rapid UI development.

Choose one strategy and stick with it for consistency.

---

## Performance Optimization

### 1. **Memoization with `useMemo` and `useCallback`**
- **`useMemo`:** Memoizes the result of a function, re-computing it only when its dependencies change. Use it for expensive calculations.
- **`useCallback`:** Memoizes a function, preventing it from being re-created on every render. This is useful when passing callbacks to memoized child components.

### 2. **Lazy Loading with `React.lazy` and `Suspense`**
- **Why:** Split your code into smaller chunks and load them on demand. This can significantly reduce the initial bundle size and improve load times.
- **Example:**
  ```jsx
  import React, { Suspense, lazy } from 'react';

  const OtherComponent = lazy(() => import('./OtherComponent'));

  function MyComponent() {
    return (
      <div>
        <Suspense fallback={<div>Loading...</div>}>
          <OtherComponent />
        </Suspense>
      </div>
    );
  }
  ```

### 3. **Windowing for Large Lists**
- **Why:** When rendering large lists of data, only render the items that are currently visible in the viewport. Libraries like `react-window` or `react-virtualized` can help with this.

---

## Testing

### 1. **Write Meaningful Tests**
- **Why:** Tests ensure your application works as expected and prevent regressions. Focus on testing the user-facing behavior of your components, not implementation details.

### 2. **Use the Right Tools**
- **Jest:** A popular testing framework for running tests.
- **React Testing Library:** A library for testing React components in a way that resembles how a user interacts with them.

---

## Keys in Lists

### 1. **Use Stable and Unique Keys**
- **Why:** Keys help React identify which items have changed, are added, or are removed. Using a stable and unique identifier (like an `id` from your data) is crucial for performance and correct behavior.
- **Anti-Pattern:** Avoid using the array index as a key, especially if the list can be reordered. This can lead to incorrect rendering and state issues.
  ```jsx
  // Bad
  items.map((item, index) => <li key={index}>{item.text}</li>)

  // Good
  items.map(item => <li key={item.id}>{item.text}</li>)
  ```

---

## Error Handling

### 1. **Use Error Boundaries**
- **Why:** Error boundaries are React components that catch JavaScript errors anywhere in their child component tree, log those errors, and display a fallback UI instead of the component tree that crashed.
- **Example:**
  ```jsx
  class ErrorBoundary extends React.Component {
    // ... (implementation)
  }

  <ErrorBoundary>
    <MyComponent />
  </ErrorBoundary>
  ```

---

## Accessibility (a11y)

### 1. **Write Semantic HTML**
- **Why:** Using correct HTML5 elements (`<nav>`, `<main>`, `<button>`, etc.) provides meaning to the structure of your application, which is essential for screen readers.

### 2. **Use ARIA Attributes When Necessary**
- **Why:** When semantic HTML is not enough, use ARIA (Accessible Rich Internet Applications) attributes to make your components more accessible.

### 3. **Manage Focus**
- **Why:** Ensure that your application is navigable with a keyboard and that focus is managed logically, especially in dynamic UIs like modals and dialogs.
