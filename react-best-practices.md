# React Best Practices

## Table of Contents
1. [Component Structure](#component-structure)
2. [State Management](#state-management)
3. [Props and PropTypes](#props-and-proptypes)
4. [Hooks](#hooks)
5. [Performance Optimization](#performance-optimization)
6. [Code Organization](#code-organization)
7. [Error Handling](#error-handling)
8. [Testing](#testing)
9. [Accessibility](#accessibility)
10. [Security](#security)

## Component Structure

### Functional Components
- **Prefer functional components** over class components for new development
- Use arrow functions for concise component definitions
- Order component elements consistently: imports, types, component, export

```jsx
import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';

const UserProfile = ({ userId, onUpdate }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(userId).then(setUser).finally(() => setLoading(false));
  }, [userId]);

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>User not found</div>;

  return (
    <div className="user-profile">
      <h2>{user.name}</h2>
      <p>{user.email}</p>
    </div>
  );
};

UserProfile.propTypes = {
  userId: PropTypes.string.isRequired,
  onUpdate: PropTypes.func
};

export default UserProfile;
```

### Component Naming
- Use **PascalCase** for component names
- Use descriptive names that clearly indicate the component's purpose
- Avoid generic names like `Component` or `Item`

```jsx
// Good
const UserDashboard = () => { /* ... */ };
const ProductCard = () => { /* ... */ };
const NavigationMenu = () => { /* ... */ };

// Bad
const Dashboard = () => { /* ... */ };
const Card = () => { /* ... */ };
const Menu = () => { /* ... */ };
```

## State Management

### Local State
- Use `useState` for component-level state
- Keep state as close to where it's used as possible
- Prefer multiple state variables over complex state objects

```jsx
// Good
const [name, setName] = useState('');
const [email, setEmail] = useState('');
const [loading, setLoading] = useState(false);

// Less ideal for simple cases
const [formState, setFormState] = useState({
  name: '',
  email: '',
  loading: false
});
```

### State Updates
- Always use functional updates when the new state depends on the previous state
- Avoid direct state mutation

```jsx
// Good
setCount(prevCount => prevCount + 1);
setItems(prevItems => [...prevItems, newItem]);

// Bad
setCount(count + 1);
items.push(newItem);
setItems(items);
```

### Global State
- Use Context API for app-wide state that doesn't change frequently
- Consider state management libraries (Redux, Zustand) for complex applications
- Avoid prop drilling by lifting state up appropriately

## Props and PropTypes

### Props Design
- Keep props simple and focused
- Use destructuring for cleaner code
- Provide default values using defaultProps or default parameters

```jsx
const Button = ({ 
  children, 
  variant = 'primary', 
  size = 'medium', 
  disabled = false,
  onClick 
}) => {
  const className = `btn btn-${variant} btn-${size}`;
  
  return (
    <button 
      className={className} 
      disabled={disabled} 
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

### PropTypes Validation
- Always define PropTypes for props validation in development
- Use specific PropTypes rather than generic ones
- Mark required props explicitly

```jsx
Button.propTypes = {
  children: PropTypes.node.isRequired,
  variant: PropTypes.oneOf(['primary', 'secondary', 'danger']),
  size: PropTypes.oneOf(['small', 'medium', 'large']),
  disabled: PropTypes.bool,
  onClick: PropTypes.func
};
```

## Hooks

### Built-in Hooks Best Practices

#### useState
- Initialize state with the correct data type
- Use functional updates for state that depends on previous state

#### useEffect
- Always include dependencies in the dependency array
- Use multiple useEffect hooks for different concerns
- Clean up side effects to prevent memory leaks

```jsx
const DataFetcher = ({ url }) => {
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    const controller = new AbortController();
    
    const fetchData = async () => {
      try {
        const response = await fetch(url, { 
          signal: controller.signal 
        });
        const result = await response.json();
        setData(result);
      } catch (err) {
        if (!controller.signal.aborted) {
          setError(err);
        }
      }
    };

    fetchData();

    return () => controller.abort();
  }, [url]);

  // Component render logic...
};
```

### Custom Hooks
- Extract reusable logic into custom hooks
- Follow the "use" naming convention
- Return objects for multiple values instead of arrays when appropriate

```jsx
const useApi = (url) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        const result = await response.json();
        setData(result);
      } catch (err) {
        setError(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [url]);

  return { data, loading, error };
};
```

## Performance Optimization

### React.memo
- Use React.memo for components that receive the same props frequently
- Provide custom comparison function when needed

```jsx
const ExpensiveComponent = React.memo(({ data, onUpdate }) => {
  // Expensive rendering logic
  return <div>{/* render */}</div>;
}, (prevProps, nextProps) => {
  return prevProps.data.id === nextProps.data.id;
});
```

### useMemo and useCallback
- Use `useMemo` for expensive calculations
- Use `useCallback` for stable function references
- Don't overuse - measure performance impact

```jsx
const ProductList = ({ products, searchTerm }) => {
  const filteredProducts = useMemo(() => {
    return products.filter(product => 
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }, [products, searchTerm]);

  const handleProductClick = useCallback((productId) => {
    // Handle click logic
  }, []);

  return (
    <div>
      {filteredProducts.map(product => (
        <ProductCard 
          key={product.id} 
          product={product} 
          onClick={handleProductClick}
        />
      ))}
    </div>
  );
};
```

### Code Splitting
- Use React.lazy for route-based code splitting
- Implement proper loading states

```jsx
import React, { Suspense } from 'react';

const LazyDashboard = React.lazy(() => import('./Dashboard'));

const App = () => (
  <Suspense fallback={<div>Loading...</div>}>
    <LazyDashboard />
  </Suspense>
);
```

## Code Organization

### File Structure
```
src/
├── components/
│   ├── common/
│   │   ├── Button/
│   │   │   ├── Button.jsx
│   │   │   ├── Button.test.js
│   │   │   └── index.js
│   └── features/
│       └── UserProfile/
├── hooks/
├── contexts/
├── utils/
├── services/
└── pages/
```

### Import Organization
- Group imports by type: React, third-party, local
- Use absolute imports for better maintainability

```jsx
// React imports
import React, { useState, useEffect } from 'react';

// Third-party imports
import axios from 'axios';
import { format } from 'date-fns';

// Local imports
import Button from 'components/common/Button';
import { useAuth } from 'hooks/useAuth';
import { API_ENDPOINTS } from 'utils/constants';
```

## Error Handling

### Error Boundaries
- Implement error boundaries for graceful error handling
- Provide meaningful fallback UI

```jsx
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
    // Log to error reporting service
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-fallback">
          <h2>Something went wrong</h2>
          <p>We're sorry, but something unexpected happened.</p>
          <button onClick={() => window.location.reload()}>
            Refresh Page
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
```

### Async Error Handling
- Handle errors in async operations gracefully
- Provide user feedback for error states

```jsx
const DataComponent = () => {
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await api.getData();
        setData(response.data);
        setError(null);
      } catch (err) {
        setError('Failed to load data. Please try again.');
        console.error('Data fetch error:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!data) return <EmptyState />;

  return <DataDisplay data={data} />;
};
```

## Testing

### Component Testing
- Test component behavior, not implementation details
- Use React Testing Library for user-centric testing
- Test different states and user interactions

```jsx
import { render, screen, fireEvent } from '@testing-library/react';
import Button from './Button';

describe('Button', () => {
  test('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  test('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  test('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

### Hook Testing
- Use @testing-library/react-hooks for testing custom hooks

```jsx
import { renderHook, act } from '@testing-library/react-hooks';
import useCounter from './useCounter';

describe('useCounter', () => {
  test('initializes with default value', () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });

  test('increments count', () => {
    const { result } = renderHook(() => useCounter());
    
    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```

## Accessibility

### Semantic HTML
- Use semantic HTML elements when possible
- Provide proper ARIA labels and roles

```jsx
const Modal = ({ isOpen, onClose, title, children }) => {
  if (!isOpen) return null;

  return (
    <div 
      className="modal-overlay" 
      role="dialog" 
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <div className="modal-content">
        <header className="modal-header">
          <h2 id="modal-title">{title}</h2>
          <button 
            onClick={onClose}
            aria-label="Close modal"
            className="close-button"
          >
            ×
          </button>
        </header>
        <main className="modal-body">
          {children}
        </main>
      </div>
    </div>
  );
};
```

### Keyboard Navigation
- Ensure all interactive elements are keyboard accessible
- Implement proper focus management

```jsx
const Dropdown = ({ options, onSelect }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(-1);

  const handleKeyDown = (event) => {
    switch (event.key) {
      case 'Enter':
      case ' ':
        if (selectedIndex >= 0) {
          onSelect(options[selectedIndex]);
          setIsOpen(false);
        }
        break;
      case 'ArrowDown':
        setSelectedIndex(prev => 
          prev < options.length - 1 ? prev + 1 : 0
        );
        break;
      case 'ArrowUp':
        setSelectedIndex(prev => 
          prev > 0 ? prev - 1 : options.length - 1
        );
        break;
      case 'Escape':
        setIsOpen(false);
        break;
    }
  };

  return (
    <div className="dropdown" onKeyDown={handleKeyDown}>
      {/* Dropdown implementation */}
    </div>
  );
};
```

## Security

### Input Sanitization
- Never trust user input
- Sanitize data before rendering
- Use libraries like DOMPurify for HTML sanitization

```jsx
import DOMPurify from 'dompurify';

const UserContent = ({ htmlContent }) => {
  const sanitizedHTML = DOMPurify.sanitize(htmlContent);
  
  return (
    <div 
      dangerouslySetInnerHTML={{ __html: sanitizedHTML }}
    />
  );
};
```

### Avoid Direct DOM Manipulation
- Use React's declarative approach instead of direct DOM manipulation
- Be cautious with dangerouslySetInnerHTML

### Environment Variables
- Never expose sensitive data in client-side code
- Use proper environment variable naming conventions

```jsx
// Good - public environment variables
const API_URL = process.env.REACT_APP_API_URL;

// Bad - sensitive data should not be in client-side code
const API_KEY = process.env.REACT_APP_API_KEY; // Don't do this!
```

## Additional Best Practices

### Consistent Formatting
- Use Prettier for code formatting
- Configure ESLint for code quality
- Establish team coding standards

### Documentation
- Write clear component documentation
- Use JSDoc comments for complex functions
- Maintain up-to-date README files

### Version Control
- Write meaningful commit messages
- Use feature branches for development
- Review code before merging

### Performance Monitoring
- Use React DevTools for debugging
- Monitor bundle size
- Implement error tracking in production

---

This document provides a comprehensive overview of React best practices. Remember that best practices evolve with the React ecosystem, so stay updated with the latest recommendations from the React team and community.