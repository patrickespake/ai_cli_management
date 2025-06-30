# React Best Practices

## Table of Contents
1. [Project Structure](#project-structure)
2. [Component Design](#component-design)
3. [State Management](#state-management)
4. [Performance Optimization](#performance-optimization)
5. [Code Quality](#code-quality)
6. [Testing](#testing)
7. [Security](#security)
8. [Accessibility](#accessibility)
9. [Build and Deployment](#build-and-deployment)

## Project Structure

### Folder Organization
```
src/
├── components/          # Reusable UI components
│   ├── common/         # Generic components (Button, Input, Modal)
│   └── feature/        # Feature-specific components
├── pages/              # Route components
├── hooks/              # Custom hooks
├── utils/              # Utility functions
├── services/           # API services
├── contexts/           # React contexts
├── constants/          # Application constants
├── types/              # TypeScript type definitions
├── styles/             # Global styles and themes
└── __tests__/          # Test files
```

### File Naming Conventions
- **Components**: PascalCase (e.g., `UserProfile.tsx`)
- **Hooks**: camelCase starting with "use" (e.g., `useAuth.ts`)
- **Utilities**: camelCase (e.g., `formatDate.ts`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_ENDPOINTS.ts`)

## Component Design

### Functional Components Over Class Components
```tsx
// ✅ Preferred: Functional Component
const UserProfile: React.FC<UserProfileProps> = ({ user, onEdit }) => {
  const [isEditing, setIsEditing] = useState(false);
  
  return (
    <div className="user-profile">
      {isEditing ? (
        <EditForm user={user} onSave={onEdit} />
      ) : (
        <DisplayProfile user={user} />
      )}
    </div>
  );
};

// ❌ Avoid: Class Component (unless necessary)
class UserProfile extends React.Component {
  // Class component implementation
}
```

### Component Composition
```tsx
// ✅ Good: Composable components
const Card: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="card">{children}</div>
);

const CardHeader: React.FC<{ title: string }> = ({ title }) => (
  <div className="card-header">{title}</div>
);

const CardBody: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="card-body">{children}</div>
);

// Usage
<Card>
  <CardHeader title="User Details" />
  <CardBody>
    <UserProfile user={user} />
  </CardBody>
</Card>
```

### Props Interface Design
```tsx
// ✅ Well-defined prop interfaces
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  loading?: boolean;
  onClick: () => void;
  children: React.ReactNode;
  'data-testid'?: string;
}

const Button: React.FC<ButtonProps> = ({
  variant,
  size = 'medium',
  disabled = false,
  loading = false,
  onClick,
  children,
  'data-testid': testId
}) => {
  // Component implementation
};
```

## State Management

### Use useState for Local State
```tsx
// ✅ Simple local state
const Counter: React.FC = () => {
  const [count, setCount] = useState(0);
  
  const increment = useCallback(() => {
    setCount(prev => prev + 1);
  }, []);
  
  return (
    <div>
      <span>{count}</span>
      <button onClick={increment}>Increment</button>
    </div>
  );
};
```

### Use useReducer for Complex State Logic
```tsx
// ✅ Complex state with useReducer
interface FormState {
  values: Record<string, string>;
  errors: Record<string, string>;
  isSubmitting: boolean;
}

type FormAction = 
  | { type: 'SET_FIELD'; field: string; value: string }
  | { type: 'SET_ERROR'; field: string; error: string }
  | { type: 'SET_SUBMITTING'; isSubmitting: boolean };

const formReducer = (state: FormState, action: FormAction): FormState => {
  switch (action.type) {
    case 'SET_FIELD':
      return {
        ...state,
        values: { ...state.values, [action.field]: action.value },
        errors: { ...state.errors, [action.field]: '' }
      };
    case 'SET_ERROR':
      return {
        ...state,
        errors: { ...state.errors, [action.field]: action.error }
      };
    case 'SET_SUBMITTING':
      return { ...state, isSubmitting: action.isSubmitting };
    default:
      return state;
  }
};
```

### Context for Global State
```tsx
// ✅ Auth context example
interface AuthContextType {
  user: User | null;
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  
  const login = useCallback(async (credentials: LoginCredentials) => {
    setIsLoading(true);
    try {
      const user = await authService.login(credentials);
      setUser(user);
    } finally {
      setIsLoading(false);
    }
  }, []);
  
  const logout = useCallback(() => {
    setUser(null);
    authService.logout();
  }, []);
  
  return (
    <AuthContext.Provider value={{ user, login, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};
```

## Performance Optimization

### Memoization
```tsx
// ✅ Memoize expensive calculations
const ExpensiveComponent: React.FC<{ data: DataType[] }> = ({ data }) => {
  const processedData = useMemo(() => {
    return data.map(item => expensiveProcessing(item));
  }, [data]);
  
  return <div>{/* Render processed data */}</div>;
};

// ✅ Memoize callback functions
const UserList: React.FC<{ users: User[] }> = ({ users }) => {
  const handleUserClick = useCallback((userId: string) => {
    // Handle user click
  }, []);
  
  return (
    <div>
      {users.map(user => (
        <UserItem 
          key={user.id} 
          user={user} 
          onClick={handleUserClick} 
        />
      ))}
    </div>
  );
};
```

### React.memo for Component Memoization
```tsx
// ✅ Memoize components that receive stable props
const UserItem = React.memo<UserItemProps>(({ user, onClick }) => {
  return (
    <div onClick={() => onClick(user.id)}>
      {user.name}
    </div>
  );
});
```

### Code Splitting and Lazy Loading
```tsx
// ✅ Lazy load components
const LazyDashboard = lazy(() => import('./Dashboard'));
const LazyProfile = lazy(() => import('./Profile'));

const App: React.FC = () => {
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

## Code Quality

### TypeScript Usage
```tsx
// ✅ Strong typing
interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'moderator';
  createdAt: Date;
}

// ✅ Generic types for reusable components
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string;
}

const List = <T,>({ items, renderItem, keyExtractor }: ListProps<T>) => {
  return (
    <ul>
      {items.map(item => (
        <li key={keyExtractor(item)}>
          {renderItem(item)}
        </li>
      ))}
    </ul>
  );
};
```

### Error Boundaries
```tsx
// ✅ Error boundary implementation
interface ErrorBoundaryState {
  hasError: boolean;
  error?: Error;
}

class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  ErrorBoundaryState
> {
  constructor(props: { children: React.ReactNode }) {
    super(props);
    this.state = { hasError: false };
  }
  
  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }
  
  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return (
        <div className="error-boundary">
          <h2>Something went wrong</h2>
          <button onClick={() => this.setState({ hasError: false })}>
            Try again
          </button>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

### Custom Hooks
```tsx
// ✅ Custom hook for API calls
const useApi = <T,>(url: string) => {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch');
        const result = await response.json();
        setData(result);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error');
      } finally {
        setLoading(false);
      }
    };
    
    fetchData();
  }, [url]);
  
  return { data, loading, error };
};
```

## Testing

### Component Testing with React Testing Library
```tsx
// ✅ Component test example
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button onClick={jest.fn()}>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });
  
  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
  
  it('is disabled when loading', () => {
    render(<Button onClick={jest.fn()} loading>Click me</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

### Hook Testing
```tsx
// ✅ Custom hook test
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('initializes with default value', () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });
  
  it('increments count', () => {
    const { result } = renderHook(() => useCounter());
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(1);
  });
});
```

## Security

### Input Sanitization
```tsx
// ✅ Sanitize user input
import DOMPurify from 'dompurify';

const UserContent: React.FC<{ content: string }> = ({ content }) => {
  const sanitizedContent = useMemo(() => {
    return DOMPurify.sanitize(content);
  }, [content]);
  
  return (
    <div 
      dangerouslySetInnerHTML={{ __html: sanitizedContent }}
    />
  );
};
```

### Environment Variables
```tsx
// ✅ Environment variable validation
const config = {
  apiUrl: process.env.REACT_APP_API_URL || 'http://localhost:3001',
  apiKey: process.env.REACT_APP_API_KEY,
};

// Validate required environment variables
if (!config.apiKey) {
  throw new Error('REACT_APP_API_KEY is required');
}
```

## Accessibility

### Semantic HTML and ARIA
```tsx
// ✅ Accessible form component
const LoginForm: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});
  
  return (
    <form onSubmit={handleSubmit} noValidate>
      <div>
        <label htmlFor="email">Email</label>
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
          <div id="email-error" role="alert">
            {errors.email}
          </div>
        )}
      </div>
      
      <div>
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
          <div id="password-error" role="alert">
            {errors.password}
          </div>
        )}
      </div>
      
      <button type="submit">Log In</button>
    </form>
  );
};
```

### Focus Management
```tsx
// ✅ Focus management in modals
const Modal: React.FC<ModalProps> = ({ isOpen, onClose, children }) => {
  const modalRef = useRef<HTMLDivElement>(null);
  
  useEffect(() => {
    if (isOpen) {
      modalRef.current?.focus();
    }
  }, [isOpen]);
  
  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === 'Escape') {
      onClose();
    }
  };
  
  if (!isOpen) return null;
  
  return (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      tabIndex={-1}
      onKeyDown={handleKeyDown}
      className="modal-overlay"
    >
      <div className="modal-content">
        {children}
      </div>
    </div>
  );
};
```

## Build and Deployment

### Build Optimization
```json
// package.json build scripts
{
  "scripts": {
    "build": "react-scripts build",
    "build:analyze": "npm run build && npx webpack-bundle-analyzer build/static/js/*.js",
    "build:prod": "NODE_ENV=production npm run build"
  }
}
```

### Environment Configuration
```bash
# .env.production
REACT_APP_API_URL=https://api.production.com
REACT_APP_ENV=production
GENERATE_SOURCEMAP=false
```

### Performance Monitoring
```tsx
// ✅ Performance monitoring
const App: React.FC = () => {
  useEffect(() => {
    // Monitor Core Web Vitals
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) => {
      getCLS(console.log);
      getFID(console.log);
      getFCP(console.log);
      getLCP(console.log);
      getTTFB(console.log);
    });
  }, []);
  
  return <div>App content</div>;
};
```

## Additional Best Practices

### 1. Consistent Naming Conventions
- Use descriptive, meaningful names
- Follow established patterns within the project
- Use TypeScript for better IDE support

### 2. Component Documentation
```tsx
/**
 * Button component for user interactions
 * @param variant - Visual style variant
 * @param size - Button size
 * @param disabled - Whether button is disabled
 * @param loading - Whether button is in loading state
 * @param onClick - Click handler function
 * @param children - Button content
 */
const Button: React.FC<ButtonProps> = ({ /* props */ }) => {
  // Implementation
};
```

### 3. Code Organization
- Keep components small and focused
- Extract complex logic into custom hooks
- Use absolute imports for better maintainability
- Group related functionality together

### 4. Performance Monitoring
- Use React DevTools Profiler
- Monitor bundle size
- Implement lazy loading for routes
- Use service workers for caching

This comprehensive guide covers the essential best practices for React development, focusing on maintainable, performant, and accessible applications.