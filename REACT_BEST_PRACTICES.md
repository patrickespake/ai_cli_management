# React Best Practices

This document outlines the best practices for developing robust, scalable, and maintainable applications using React.

## 1. Component Architecture

### Use Functional Components with Hooks
Prefer functional components and Hooks over class-based components for new development. They lead to more concise, readable, and easier-to-test code.

```jsx
// Good
import React, { useState, useEffect } from 'react';

function MyComponent({ prop }) {
  const [state, setState] = useState('');

  useEffect(() => {
    // Side effects here
  }, [prop]);

  return <div>{prop}</div>;
}
```

### Keep Components Small and Focused (Single Responsibility)
Each component should have a single responsibility. If a component grows too large or handles too many concerns, break it down into smaller, more specialized components.

### Use Composition
Favor composition over inheritance. Create reusable components and compose them to build complex UIs. The "Container/Presentational" pattern is a good example, where container components manage logic and data, and presentational components focus on the UI.

## 2. State Management

### Local State with `useState`
For state that is local to a single component, `useState` is the simplest and most efficient choice.

### Complex State with `useReducer`
When state logic is complex or involves multiple sub-values, `useReducer` can be a better alternative to `useState`. It's particularly useful when the next state depends on the previous one.

### Global State
- **`useContext`**: For passing data through the component tree without prop drilling. It's best for low-frequency updates like theme, user authentication, etc. Be aware that any component consuming the context will re-render when the context value changes.
- **External Libraries (Redux, Zustand, Jotai)**: For complex, global application state that is updated frequently, consider using a dedicated state management library.

## 3. Props

### Use TypeScript or PropTypes
Always define the shape of your props. TypeScript is the recommended approach for type safety in modern React applications. If you're not using TypeScript, use the `prop-types` library.

```jsx
// With TypeScript
interface MyComponentProps {
  name: string;
  age: number;
}

function MyComponent({ name, age }: MyComponentProps) {
  return <div>{name}, {age}</div>;
}
```

### Avoid Prop Drilling
Prop drilling is passing props down through multiple layers of components. To avoid this, use:
- **Component Composition**: Pass components as props.
- **`useContext`**: For global data.
- **State Management Libraries**: For application-wide state.

## 4. Hooks

### Follow the Rules of Hooks
- Only call Hooks at the top level of your functional components.
- Only call Hooks from React functions (components or custom Hooks).

### `useEffect` for Side Effects
Manage side effects like data fetching, subscriptions, or manual DOM manipulations in `useEffect`. Always provide a dependency array to avoid re-running the effect on every render.

```jsx
useEffect(() => {
  // This runs only when `userId` changes
  fetchData(userId);
}, [userId]);
```

### Optimize with `useMemo` and `useCallback`
- **`useMemo`**: Memoize the result of a complex calculation.
- **`useCallback`**: Memoize a function definition, preventing re-creation on every render. This is crucial when passing callbacks to optimized child components.

### Create Custom Hooks
Encapsulate and reuse stateful logic by creating custom Hooks. This is a powerful way to share logic across components without using higher-order components or render props.

```jsx
function useUserData(userId) {
  const [user, setUser] = useState(null);

  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);

  return user;
}
```

## 5. Styling

Choose a consistent styling strategy:
- **CSS Modules**: Scope CSS locally to a component, avoiding global namespace conflicts.
- **CSS-in-JS (e.g., Styled-components, Emotion)**: Co-locate your styles with your components for better organization.
- **Utility-First CSS (e.g., Tailwind CSS)**: Rapidly build UIs without writing custom CSS.

## 6. Testing

### Use Jest and React Testing Library
Write tests that focus on user behavior and component functionality, not on implementation details. React Testing Library encourages this approach.

- **Unit Tests**: Test individual components in isolation.
- **Integration Tests**: Test how multiple components work together.
- **Mocking**: Mock API calls, modules, and functions to isolate the component under test.

## 7. Performance

### Code Splitting
Use `React.lazy` and `Suspense` to split your code into smaller chunks, loading them on demand. This can significantly improve initial load time.

### Memoization
Use `React.memo` to prevent a component from re-rendering if its props haven't changed. Combine with `useMemo` and `useCallback` for optimal performance.

### Virtualization for Long Lists
For rendering large lists of data, use a windowing library like `react-window` or `react-virtualized` to render only the items currently visible in the viewport.

## 8. Security

### Prevent XSS
React automatically escapes content rendered in JSX, which helps prevent Cross-Site Scripting (XSS) attacks. Avoid using `dangerouslySetInnerHTML` unless you are working with trusted, sanitized HTML.

### Secure API Keys
Never expose API keys or other secrets in your client-side code. Store them in backend services or use serverless functions to make API requests.

## 9. File Structure

Organize your files in a way that is scalable and easy to navigate. A feature-based folder structure is often more scalable than a file-type-based structure.

```
/src
  /components
    /Button
      - index.tsx
      - Button.test.tsx
      - Button.module.css
  /features
    /Authentication
      - Login.tsx
      - authSlice.ts
      - useAuth.ts
  /hooks
  /lib
```

## 10. General Best Practices

- **Keys for Lists**: Always provide a stable and unique `key` prop when rendering lists of elements.
- **Fragments**: Use `<>` or `<React.Fragment>` to group elements without adding an extra node to the DOM.
- **Error Boundaries**: Create error boundary components to catch JavaScript errors in their child component tree and display a fallback UI.
- **Strict Mode**: Use `<React.StrictMode>` to highlight potential problems in your application during development.
