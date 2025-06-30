# React Best Practices

## Table of Contents
1. [Component Architecture](#component-architecture)
2. [State Management](#state-management)
3. [Performance Optimization](#performance-optimization)
4. [Code Organization](#code-organization)
5. [Styling Best Practices](#styling-best-practices)
6. [Error Handling](#error-handling)
7. [Testing](#testing)
8. [Security](#security)
9. [Accessibility](#accessibility)
10. [Development Workflow](#development-workflow)

## Component Architecture

### Functional Components Over Class Components
Use functional components with hooks instead of class components for better performance and cleaner code.

```jsx
// ✅ Good - Functional component
const UserProfile = ({ userId }) => {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  
  return <div>{user?.name}</div>;
};

// ❌ Avoid - Class component
class UserProfile extends React.Component {
  constructor(props) {
    super(props);
    this.state = { user: null };
  }
  
  componentDidMount() {
    fetchUser(this.props.userId).then(user => {
      this.setState({ user });
    });
  }
  
  render() {
    return <div>{this.state.user?.name}</div>;
  }
}
```

### Component Composition
Favor composition over inheritance for better reusability and flexibility.

```jsx
// ✅ Good - Composition
const Card = ({ children, className = '' }) => (
  <div className={`card ${className}`}>
    {children}
  </div>
);

const CardHeader = ({ children }) => (
  <div className="card-header">{children}</div>
);

const CardBody = ({ children }) => (
  <div className="card-body">{children}</div>
);

// Usage
<Card>
  <CardHeader>User Profile</CardHeader>
  <CardBody>
    <UserDetails user={user} />
  </CardBody>
</Card>
```

### Single Responsibility Principle
Each component should have a single, well-defined responsibility.

```jsx
// ✅ Good - Separated concerns
const UserAvatar = ({ src, alt, size = 'medium' }) => (
  <img 
    src={src} 
    alt={alt} 
    className={`avatar avatar-${size}`}
  />
);

const UserName = ({ name, isOnline }) => (
  <span className={`username ${isOnline ? 'online' : 'offline'}`}>
    {name}
  </span>
);

const UserProfile = ({ user }) => (
  <div className="user-profile">
    <UserAvatar src={user.avatar} alt={user.name} />
    <UserName name={user.name} isOnline={user.isOnline} />
  </div>
);
```

## State Management

### Use useState for Local State
Keep component state local when it doesn't need to be shared.

```jsx
// ✅ Good - Local state
const Counter = () => {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <span>{count}</span>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  );
};
```

### Use useReducer for Complex State Logic
When state logic becomes complex, use useReducer instead of multiple useState calls.

```jsx
// ✅ Good - useReducer for complex state
const todoReducer = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [...state, { id: Date.now(), text: action.text, completed: false }];
    case 'TOGGLE_TODO':
      return state.map(todo =>
        todo.id === action.id ? { ...todo, completed: !todo.completed } : todo
      );
    case 'REMOVE_TODO':
      return state.filter(todo => todo.id !== action.id);
    default:
      return state;
  }
};

const TodoApp = () => {
  const [todos, dispatch] = useReducer(todoReducer, []);
  
  const addTodo = (text) => {
    dispatch({ type: 'ADD_TODO', text });
  };
  
  return (
    <div>
      {todos.map(todo => (
        <TodoItem 
          key={todo.id} 
          todo={todo} 
          onToggle={() => dispatch({ type: 'TOGGLE_TODO', id: todo.id })}
          onRemove={() => dispatch({ type: 'REMOVE_TODO', id: todo.id })}
        />
      ))}
    </div>
  );
};
```

### Lift State Up When Needed
Move state to the closest common ancestor when multiple components need to share it.

```jsx
// ✅ Good - State lifted to common parent
const ShoppingApp = () => {
  const [cart, setCart] = useState([]);
  
  const addToCart = (item) => {
    setCart(prev => [...prev, item]);
  };
  
  return (
    <div>
      <ProductList onAddToCart={addToCart} />
      <Cart items={cart} />
    </div>
  );
};
```

## Performance Optimization

### Use React.memo for Pure Components
Wrap components in React.memo to prevent unnecessary re-renders.

```jsx
// ✅ Good - Memoized component
const ExpensiveComponent = React.memo(({ data, onAction }) => {
  const processedData = useMemo(() => {
    return data.map(item => ({
      ...item,
      processed: heavyComputation(item)
    }));
  }, [data]);
  
  return (
    <div>
      {processedData.map(item => (
        <Item key={item.id} item={item} onClick={onAction} />
      ))}
    </div>
  );
});
```

### Use useMemo and useCallback
Optimize expensive calculations and prevent unnecessary function recreations.

```jsx
// ✅ Good - Using useMemo and useCallback
const ProductList = ({ products, onProductClick }) => {
  const expensiveValue = useMemo(() => {
    return products.reduce((acc, product) => acc + product.price, 0);
  }, [products]);
  
  const handleClick = useCallback((productId) => {
    onProductClick(productId);
  }, [onProductClick]);
  
  return (
    <div>
      <p>Total: ${expensiveValue}</p>
      {products.map(product => (
        <Product 
          key={product.id} 
          product={product} 
          onClick={handleClick}
        />
      ))}
    </div>
  );
};
```

### Lazy Loading with React.lazy
Load components only when needed to reduce initial bundle size.

```jsx
// ✅ Good - Lazy loading
const LazyDashboard = React.lazy(() => import('./Dashboard'));
const LazyProfile = React.lazy(() => import('./Profile'));

const App = () => {
  return (
    <Router>
      <Suspense fallback={<LoadingSpinner />}>
        <Routes>
          <Route path="/dashboard" element={<LazyDashboard />} />
          <Route path="/profile" element={<LazyProfile />} />
        </Routes>
      </Suspense>
    </Router>
  );
};
```

## Code Organization

### File and Folder Structure
Organize files by feature rather than by type.

```
src/
  components/
    common/
      Button/
        Button.jsx
        Button.test.js
        Button.styles.js
        index.js
  features/
    user/
      components/
        UserProfile.jsx
        UserList.jsx
      hooks/
        useUser.js
      services/
        userApi.js
      index.js
  hooks/
    useAuth.js
    useLocalStorage.js
  utils/
    helpers.js
    constants.js
```

### Custom Hooks for Reusable Logic
Extract reusable stateful logic into custom hooks.

```jsx
// ✅ Good - Custom hook
const useLocalStorage = (key, initialValue) => {
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(`Error reading localStorage key "${key}":`, error);
      return initialValue;
    }
  });
  
  const setValue = (value) => {
    try {
      setStoredValue(value);
      window.localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      console.error(`Error setting localStorage key "${key}":`, error);
    }
  };
  
  return [storedValue, setValue];
};

// Usage
const UserSettings = () => {
  const [theme, setTheme] = useLocalStorage('theme', 'light');
  
  return (
    <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
      Current theme: {theme}
    </button>
  );
};
```

### Environment Variables
Use environment variables for configuration.

```jsx
// ✅ Good - Environment variables
const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:3000';
const IS_DEVELOPMENT = process.env.NODE_ENV === 'development';

const apiClient = {
  get: (endpoint) => fetch(`${API_BASE_URL}${endpoint}`),
  post: (endpoint, data) => fetch(`${API_BASE_URL}${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  })
};
```

## Styling Best Practices

### CSS Modules or Styled Components
Use CSS Modules or styled-components to avoid global CSS conflicts.

```jsx
// ✅ Good - CSS Modules
import styles from './Button.module.css';

const Button = ({ variant = 'primary', children, ...props }) => (
  <button 
    className={`${styles.button} ${styles[variant]}`}
    {...props}
  >
    {children}
  </button>
);

// ✅ Good - Styled Components
import styled from 'styled-components';

const StyledButton = styled.button`
  padding: 12px 24px;
  border: none;
  border-radius: 4px;
  font-weight: 600;
  cursor: pointer;
  
  background-color: ${props => 
    props.variant === 'secondary' ? '#6c757d' : '#007bff'
  };
  
  &:hover {
    opacity: 0.9;
  }
`;
```

### Responsive Design
Use CSS Grid and Flexbox for responsive layouts.

```jsx
// ✅ Good - Responsive component
const ResponsiveGrid = ({ children }) => (
  <div style={{
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
    gap: '1rem',
    padding: '1rem'
  }}>
    {children}
  </div>
);
```

## Error Handling

### Error Boundaries
Use Error Boundaries to catch and handle errors gracefully.

```jsx
// ✅ Good - Error Boundary
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
      return this.props.fallback || (
        <div>
          <h2>Something went wrong</h2>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try again
          </button>
        </div>
      );
    }
    
    return this.props.children;
  }
}

// Usage
<ErrorBoundary fallback={<ErrorFallback />}>
  <MyComponent />
</ErrorBoundary>
```

### Async Error Handling
Handle async errors properly in useEffect and event handlers.

```jsx
// ✅ Good - Async error handling
const UserProfile = ({ userId }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true);
        setError(null);
        const userData = await userApi.getUser(userId);
        setUser(userData);
      } catch (err) {
        setError(err.message);
        console.error('Failed to fetch user:', err);
      } finally {
        setLoading(false);
      }
    };
    
    fetchUser();
  }, [userId]);
  
  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!user) return <div>User not found</div>;
  
  return <UserDetails user={user} />;
};
```

## Testing

### Component Testing with React Testing Library
Write tests that focus on user behavior rather than implementation details.

```jsx
// ✅ Good - User-focused tests
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import Counter from './Counter';

describe('Counter', () => {
  test('increments count when increment button is clicked', async () => {
    const user = userEvent.setup();
    render(<Counter initialCount={0} />);
    
    const incrementButton = screen.getByRole('button', { name: /increment/i });
    const countDisplay = screen.getByTestId('count-display');
    
    expect(countDisplay).toHaveTextContent('0');
    
    await user.click(incrementButton);
    
    expect(countDisplay).toHaveTextContent('1');
  });
  
  test('handles async operations correctly', async () => {
    render(<AsyncCounter />);
    
    const asyncButton = screen.getByRole('button', { name: /async increment/i });
    
    fireEvent.click(asyncButton);
    
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
    
    await waitFor(() => {
      expect(screen.getByTestId('count-display')).toHaveTextContent('1');
    });
  });
});
```

### Custom Hook Testing
Test custom hooks in isolation.

```jsx
// ✅ Good - Custom hook testing
import { renderHook, act } from '@testing-library/react';
import useCounter from './useCounter';

describe('useCounter', () => {
  test('should initialize with correct value', () => {
    const { result } = renderHook(() => useCounter(10));
    
    expect(result.current.count).toBe(10);
  });
  
  test('should increment count', () => {
    const { result } = renderHook(() => useCounter(0));
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(1);
  });
});
```

## Security

### Sanitize User Input
Always sanitize user input to prevent XSS attacks.

```jsx
// ✅ Good - Sanitized input
import DOMPurify from 'dompurify';

const UserContent = ({ htmlContent }) => {
  const sanitizedContent = DOMPurify.sanitize(htmlContent);
  
  return (
    <div 
      dangerouslySetInnerHTML={{ __html: sanitizedContent }}
    />
  );
};

// ✅ Good - Controlled input
const CommentForm = ({ onSubmit }) => {
  const [comment, setComment] = useState('');
  
  const handleSubmit = (e) => {
    e.preventDefault();
    // Validate and sanitize before submitting
    const sanitizedComment = comment.trim();
    if (sanitizedComment.length > 0 && sanitizedComment.length <= 500) {
      onSubmit(sanitizedComment);
    }
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <textarea
        value={comment}
        onChange={(e) => setComment(e.target.value)}
        maxLength={500}
        required
      />
      <button type="submit">Submit</button>
    </form>
  );
};
```

### Secure API Calls
Implement proper authentication and error handling for API calls.

```jsx
// ✅ Good - Secure API client
const createApiClient = (baseURL, authToken) => {
  const client = {
    get: async (endpoint) => {
      const response = await fetch(`${baseURL}${endpoint}`, {
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json'
        }
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return response.json();
    },
    
    post: async (endpoint, data) => {
      const response = await fetch(`${baseURL}${endpoint}`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return response.json();
    }
  };
  
  return client;
};
```

## Accessibility

### Semantic HTML and ARIA
Use semantic HTML elements and ARIA attributes for better accessibility.

```jsx
// ✅ Good - Accessible form
const LoginForm = ({ onSubmit }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState({});
  
  return (
    <form onSubmit={onSubmit} noValidate>
      <div className="form-group">
        <label htmlFor="email">Email Address</label>
        <input
          id="email"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          aria-describedby={errors.email ? 'email-error' : undefined}
          aria-invalid={!!errors.email}
          required
        />
        {errors.email && (
          <div id="email-error" role="alert" className="error">
            {errors.email}
          </div>
        )}
      </div>
      
      <div className="form-group">
        <label htmlFor="password">Password</label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          aria-describedby={errors.password ? 'password-error' : undefined}
          aria-invalid={!!errors.password}
          required
        />
        {errors.password && (
          <div id="password-error" role="alert" className="error">
            {errors.password}
          </div>
        )}
      </div>
      
      <button type="submit">Sign In</button>
    </form>
  );
};
```

### Keyboard Navigation
Ensure all interactive elements are accessible via keyboard.

```jsx
// ✅ Good - Keyboard accessible dropdown
const Dropdown = ({ options, onSelect, placeholder }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(-1);
  
  const handleKeyDown = (e) => {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        setSelectedIndex(prev => 
          prev < options.length - 1 ? prev + 1 : 0
        );
        break;
      case 'ArrowUp':
        e.preventDefault();
        setSelectedIndex(prev => 
          prev > 0 ? prev - 1 : options.length - 1
        );
        break;
      case 'Enter':
        e.preventDefault();
        if (selectedIndex >= 0) {
          onSelect(options[selectedIndex]);
          setIsOpen(false);
        }
        break;
      case 'Escape':
        setIsOpen(false);
        break;
    }
  };
  
  return (
    <div className="dropdown">
      <button
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        aria-expanded={isOpen}
        aria-haspopup="listbox"
      >
        {placeholder}
      </button>
      
      {isOpen && (
        <ul role="listbox" className="dropdown-menu">
          {options.map((option, index) => (
            <li
              key={option.id}
              role="option"
              aria-selected={index === selectedIndex}
              className={index === selectedIndex ? 'selected' : ''}
              onClick={() => onSelect(option)}
            >
              {option.label}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};
```

## Development Workflow

### ESLint and Prettier Configuration
Use consistent code formatting and linting rules.

```json
// .eslintrc.json
{
  "extends": [
    "react-app",
    "react-app/jest"
  ],
  "rules": {
    "react/prop-types": "warn",
    "react/no-unused-prop-types": "warn",
    "react-hooks/exhaustive-deps": "warn",
    "no-console": "warn",
    "prefer-const": "error"
  }
}

// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

### Git Hooks for Code Quality
Use pre-commit hooks to ensure code quality.

```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "git add"
    ]
  }
}
```

### TypeScript Integration
Use TypeScript for better type safety and developer experience.

```tsx
// ✅ Good - TypeScript component
interface User {
  id: string;
  name: string;
  email: string;
  isActive: boolean;
}

interface UserProfileProps {
  user: User;
  onEdit: (userId: string) => void;
  onDelete: (userId: string) => void;
}

const UserProfile: React.FC<UserProfileProps> = ({ 
  user, 
  onEdit, 
  onDelete 
}) => {
  const handleEdit = useCallback(() => {
    onEdit(user.id);
  }, [user.id, onEdit]);
  
  const handleDelete = useCallback(() => {
    onDelete(user.id);
  }, [user.id, onDelete]);
  
  return (
    <div className="user-profile">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      <div className="actions">
        <button onClick={handleEdit}>Edit</button>
        <button onClick={handleDelete}>Delete</button>
      </div>
    </div>
  );
};
```

## Conclusion

Following these React best practices will help you build maintainable, performant, and accessible applications. Remember to:

- Keep components small and focused
- Use hooks appropriately
- Optimize performance where needed
- Write comprehensive tests
- Prioritize accessibility
- Maintain consistent code style
- Handle errors gracefully
- Secure your application against common vulnerabilities

Regular code reviews and staying updated with the React ecosystem will help you continuously improve your development practices.