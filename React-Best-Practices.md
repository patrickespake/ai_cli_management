# React Best Practices Guide

## Table of Contents
1. [Project Structure](#project-structure)
2. [Component Design](#component-design)
3. [State Management](#state-management)
4. [Performance Optimization](#performance-optimization)
5. [Hooks Best Practices](#hooks-best-practices)
6. [TypeScript Integration](#typescript-integration)
7. [Testing](#testing)
8. [Code Style & Conventions](#code-style--conventions)
9. [Security Best Practices](#security-best-practices)
10. [Accessibility](#accessibility)

## Project Structure

### Recommended Folder Structure
```
src/
├── components/           # Reusable components
│   ├── common/          # Generic components (Button, Input, etc.)
│   ├── layout/          # Layout components (Header, Footer)
│   └── features/        # Feature-specific components
├── pages/               # Page components (route-based)
├── hooks/               # Custom hooks
├── services/            # API services and external integrations
├── utils/               # Utility functions
├── types/               # TypeScript type definitions
├── contexts/            # React Context providers
├── constants/           # App constants
└── assets/              # Images, fonts, etc.
```

### File Naming Conventions
- Components: PascalCase (e.g., `UserProfile.jsx`)
- Utilities/Hooks: camelCase (e.g., `useAuth.js`, `formatDate.js`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `API_ENDPOINTS.js`)
- CSS Modules: camelCase (e.g., `userProfile.module.css`)

## Component Design

### 1. Functional Components with Hooks
Always use functional components with hooks instead of class components:

```jsx
// ✅ Good
const UserProfile = ({ userId }) => {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  
  return <div>{user?.name}</div>;
};

// ❌ Avoid
class UserProfile extends React.Component {
  // Class component implementation
}
```

### 2. Component Composition
Favor composition over inheritance:

```jsx
// ✅ Good - Composition
const Card = ({ children, title }) => (
  <div className="card">
    {title && <h2>{title}</h2>}
    {children}
  </div>
);

const UserCard = ({ user }) => (
  <Card title={user.name}>
    <p>{user.email}</p>
  </Card>
);
```

### 3. Props Destructuring
Always destructure props for better readability:

```jsx
// ✅ Good
const UserAvatar = ({ src, alt, size = 'medium' }) => (
  <img src={src} alt={alt} className={`avatar-${size}`} />
);

// ❌ Avoid
const UserAvatar = (props) => (
  <img src={props.src} alt={props.alt} className={`avatar-${props.size}`} />
);
```

### 4. Prop Types and Default Props
Use TypeScript or PropTypes for type checking:

```typescript
// TypeScript approach
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({ 
  label, 
  onClick, 
  variant = 'primary',
  disabled = false 
}) => (
  <button 
    onClick={onClick} 
    disabled={disabled}
    className={`btn-${variant}`}
  >
    {label}
  </button>
);
```

## State Management

### 1. Local State vs Global State
- Use local state for component-specific data
- Use global state (Context, Redux, Zustand) for data shared across components

```jsx
// Local state for form inputs
const ContactForm = () => {
  const [formData, setFormData] = useState({ name: '', email: '' });
  // ...
};

// Global state for user authentication
const AuthContext = createContext();

const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  // ...
};
```

### 2. State Updates
Always use functional updates when new state depends on previous state:

```jsx
// ✅ Good
setCount(prevCount => prevCount + 1);

// ❌ Avoid (can cause issues with batched updates)
setCount(count + 1);
```

### 3. Complex State Management
Use useReducer for complex state logic:

```jsx
const initialState = { count: 0, isLoading: false };

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + 1 };
    case 'setLoading':
      return { ...state, isLoading: action.payload };
    default:
      return state;
  }
}

const Counter = () => {
  const [state, dispatch] = useReducer(reducer, initialState);
  // ...
};
```

## Performance Optimization

### 1. Memoization
Use React.memo for expensive components:

```jsx
const ExpensiveComponent = React.memo(({ data }) => {
  return <ComplexVisualization data={data} />;
}, (prevProps, nextProps) => {
  return prevProps.data.id === nextProps.data.id;
});
```

### 2. useMemo and useCallback
Optimize expensive calculations and callback functions:

```jsx
const DataGrid = ({ data, filter }) => {
  const filteredData = useMemo(
    () => data.filter(item => item.status === filter),
    [data, filter]
  );
  
  const handleSort = useCallback((column) => {
    // Sorting logic
  }, []);
  
  return <Grid data={filteredData} onSort={handleSort} />;
};
```

### 3. Code Splitting
Implement lazy loading for better performance:

```jsx
const Dashboard = lazy(() => import('./pages/Dashboard'));

function App() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
      </Routes>
    </Suspense>
  );
}
```

### 4. Virtual Lists
Use virtualization for long lists:

```jsx
import { FixedSizeList } from 'react-window';

const VirtualizedList = ({ items }) => (
  <FixedSizeList
    height={600}
    itemCount={items.length}
    itemSize={50}
    width="100%"
  >
    {({ index, style }) => (
      <div style={style}>
        {items[index].name}
      </div>
    )}
  </FixedSizeList>
);
```

## Hooks Best Practices

### 1. Rules of Hooks
- Only call hooks at the top level
- Only call hooks from React functions

```jsx
// ✅ Good
const Component = () => {
  const [state, setState] = useState();
  
  if (condition) {
    // Logic here
  }
};

// ❌ Avoid
const Component = () => {
  if (condition) {
    const [state, setState] = useState(); // Never call hooks conditionally
  }
};
```

### 2. Custom Hooks
Extract reusable logic into custom hooks:

```jsx
const useWindowSize = () => {
  const [size, setSize] = useState({ width: 0, height: 0 });
  
  useEffect(() => {
    const handleResize = () => {
      setSize({ width: window.innerWidth, height: window.innerHeight });
    };
    
    window.addEventListener('resize', handleResize);
    handleResize();
    
    return () => window.removeEventListener('resize', handleResize);
  }, []);
  
  return size;
};
```

### 3. useEffect Dependencies
Always include all dependencies:

```jsx
// ✅ Good
useEffect(() => {
  fetchData(userId, filters);
}, [userId, filters]);

// ❌ Avoid - missing dependencies
useEffect(() => {
  fetchData(userId, filters);
}, []); // ESLint will warn about this
```

## TypeScript Integration

### 1. Component Types
Use proper TypeScript types for components:

```typescript
interface UserProfileProps {
  user: User;
  onUpdate: (user: User) => void;
}

const UserProfile: React.FC<UserProfileProps> = ({ user, onUpdate }) => {
  // Component implementation
};
```

### 2. Event Handler Types
Type event handlers correctly:

```typescript
const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setValue(e.target.value);
};

const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
  e.preventDefault();
  // Submit logic
};
```

### 3. Generic Components
Create reusable generic components:

```typescript
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string;
}

function List<T>({ items, renderItem, keyExtractor }: ListProps<T>) {
  return (
    <ul>
      {items.map(item => (
        <li key={keyExtractor(item)}>{renderItem(item)}</li>
      ))}
    </ul>
  );
}
```

## Testing

### 1. Component Testing
Use React Testing Library for component tests:

```jsx
import { render, screen, fireEvent } from '@testing-library/react';

test('Button component', () => {
  const handleClick = jest.fn();
  render(<Button onClick={handleClick}>Click me</Button>);
  
  const button = screen.getByText('Click me');
  fireEvent.click(button);
  
  expect(handleClick).toHaveBeenCalledTimes(1);
});
```

### 2. Hook Testing
Test custom hooks with @testing-library/react-hooks:

```jsx
import { renderHook, act } from '@testing-library/react-hooks';

test('useCounter hook', () => {
  const { result } = renderHook(() => useCounter());
  
  expect(result.current.count).toBe(0);
  
  act(() => {
    result.current.increment();
  });
  
  expect(result.current.count).toBe(1);
});
```

### 3. Integration Testing
Test components with their dependencies:

```jsx
test('UserProfile fetches and displays user data', async () => {
  render(<UserProfile userId="123" />);
  
  expect(screen.getByText('Loading...')).toBeInTheDocument();
  
  await waitFor(() => {
    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });
});
```

## Code Style & Conventions

### 1. ESLint Configuration
Use strict ESLint rules:

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "rules": {
    "react/prop-types": "off",
    "react/react-in-jsx-scope": "off",
    "no-unused-vars": "error",
    "no-console": "warn"
  }
}
```

### 2. Prettier Configuration
Maintain consistent formatting:

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "jsxSingleQuote": false
}
```

### 3. Import Organization
Organize imports logically:

```jsx
// External dependencies
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

// Internal dependencies
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/common';
import { formatDate } from '@/utils/date';

// Styles
import styles from './UserProfile.module.css';
```

## Security Best Practices

### 1. Avoid dangerouslySetInnerHTML
Never use dangerouslySetInnerHTML with untrusted content:

```jsx
// ❌ Dangerous
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ Safe alternatives
<div>{userInput}</div>

// Or use a sanitization library
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />
```

### 2. Environment Variables
Store sensitive data in environment variables:

```jsx
// .env
REACT_APP_API_KEY=your-secret-key

// Usage
const apiKey = process.env.REACT_APP_API_KEY;
```

### 3. Authentication & Authorization
Implement proper authentication checks:

```jsx
const ProtectedRoute = ({ children }) => {
  const { user } = useAuth();
  
  if (!user) {
    return <Navigate to="/login" />;
  }
  
  return children;
};
```

### 4. Input Validation
Always validate user inputs:

```jsx
const handleSubmit = (formData) => {
  // Validate on client side
  if (!isValidEmail(formData.email)) {
    setError('Invalid email address');
    return;
  }
  
  // Server should also validate
  submitForm(formData);
};
```

## Accessibility

### 1. Semantic HTML
Use appropriate HTML elements:

```jsx
// ✅ Good
<button onClick={handleClick}>Submit</button>
<nav><ul>...</ul></nav>
<main>...</main>

// ❌ Avoid
<div onClick={handleClick}>Submit</div>
```

### 2. ARIA Attributes
Add ARIA attributes when needed:

```jsx
<button
  aria-label="Close dialog"
  aria-pressed={isPressed}
  onClick={onClose}
>
  <CloseIcon />
</button>

<div
  role="alert"
  aria-live="polite"
  aria-atomic="true"
>
  {errorMessage}
</div>
```

### 3. Keyboard Navigation
Ensure all interactive elements are keyboard accessible:

```jsx
const Modal = ({ isOpen, onClose, children }) => {
  useEffect(() => {
    const handleEscape = (e) => {
      if (e.key === 'Escape') onClose();
    };
    
    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
    }
    
    return () => document.removeEventListener('keydown', handleEscape);
  }, [isOpen, onClose]);
  
  return (
    <div role="dialog" aria-modal="true">
      {children}
    </div>
  );
};
```

### 4. Focus Management
Manage focus appropriately:

```jsx
const SearchInput = () => {
  const inputRef = useRef(null);
  
  useEffect(() => {
    inputRef.current?.focus();
  }, []);
  
  return <input ref={inputRef} type="search" aria-label="Search" />;
};
```

## Additional Best Practices

### 1. Error Boundaries
Implement error boundaries to catch component errors:

```jsx
class ErrorBoundary extends React.Component {
  state = { hasError: false };
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }
    
    return this.props.children;
  }
}
```

### 2. Suspense for Data Fetching
Use Suspense for better loading states:

```jsx
const UserProfile = () => {
  return (
    <Suspense fallback={<ProfileSkeleton />}>
      <UserProfileContent />
    </Suspense>
  );
};
```

### 3. Optimize Re-renders
Prevent unnecessary re-renders:

```jsx
// Split state to minimize re-renders
const Form = () => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  
  // Instead of one large state object
  // const [formData, setFormData] = useState({ name: '', email: '' });
};
```

### 4. Clean Up Effects
Always clean up side effects:

```jsx
useEffect(() => {
  const timer = setTimeout(() => {
    // Action
  }, 1000);
  
  const subscription = eventEmitter.subscribe(handler);
  
  return () => {
    clearTimeout(timer);
    subscription.unsubscribe();
  };
}, []);
```

## Conclusion

Following these React best practices will help you build maintainable, performant, and accessible applications. Remember to:

- Keep components small and focused
- Use TypeScript for better type safety
- Write comprehensive tests
- Optimize performance only when necessary
- Prioritize code readability and maintainability
- Stay updated with React's latest features and best practices

Regular code reviews and team discussions about these practices will ensure consistent implementation across your project.