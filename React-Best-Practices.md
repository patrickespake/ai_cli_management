# React Best Practices

## Table of Contents
1. [Project Structure](#project-structure)
2. [Component Design](#component-design)
3. [State Management](#state-management)
4. [Performance Optimization](#performance-optimization)
5. [Code Quality & Standards](#code-quality--standards)
6. [Testing](#testing)
7. [Security](#security)
8. [Accessibility](#accessibility)
9. [Deployment & Build](#deployment--build)

## Project Structure

### Recommended Folder Structure
```
src/
├── components/           # Reusable UI components
│   ├── ui/              # Basic UI elements (buttons, inputs, etc.)
│   ├── layout/          # Layout components (header, footer, sidebar)
│   └── common/          # Shared components across features
├── pages/               # Page-level components
├── hooks/               # Custom React hooks
├── services/            # API calls and external services
├── utils/               # Utility functions
├── contexts/            # React Context providers
├── types/               # TypeScript type definitions
├── constants/           # Application constants
├── assets/              # Static assets (images, fonts, etc.)
└── styles/              # Global styles and themes
```

### Best Practices:
- **Feature-based organization**: Group related files by feature for larger applications
- **Consistent naming**: Use PascalCase for components, camelCase for functions and variables
- **Index files**: Use `index.ts` files to create clean import paths
- **Absolute imports**: Configure path mapping to avoid `../../../` imports

## Component Design

### Functional Components
Always prefer functional components over class components:

```jsx
// ✅ Good - Functional component
const UserProfile = ({ user, onEdit }) => {
  return (
    <div className="user-profile">
      <h2>{user.name}</h2>
      <button onClick={() => onEdit(user.id)}>Edit</button>
    </div>
  );
};

// ❌ Avoid - Class component (unless specifically needed)
class UserProfile extends React.Component {
  render() {
    const { user, onEdit } = this.props;
    return (
      <div className="user-profile">
        <h2>{user.name}</h2>
        <button onClick={() => onEdit(user.id)}>Edit</button>
      </div>
    );
  }
}
```

### Component Composition
- **Single Responsibility**: Each component should have one clear purpose
- **Props Interface**: Define clear, typed props interfaces
- **Composition over Inheritance**: Use composition patterns

### Props Best Practices
```jsx
// ✅ Good - Destructured props with TypeScript
interface UserCardProps {
  user: User;
  onEdit?: (id: string) => void;
  className?: string;
  children?: React.ReactNode;
}

const UserCard: React.FC<UserCardProps> = ({ 
  user, 
  onEdit, 
  className = '', 
  children 
}) => {
  return (
    <div className={`user-card ${className}`}>
      {/* Component content */}
      {children}
    </div>
  );
};

// ❌ Avoid - Using props object directly
const UserCard = (props) => {
  return (
    <div className={`user-card ${props.className}`}>
      <h3>{props.user.name}</h3>
    </div>
  );
};
```

## State Management

### Local State with useState
```jsx
// ✅ Good - Simple local state
const [isLoading, setIsLoading] = useState(false);
const [formData, setFormData] = useState({ name: '', email: '' });

// ✅ Good - Functional updates for dependent state
const [count, setCount] = useState(0);
const increment = () => setCount(prev => prev + 1);
```

### useReducer for Complex State
```jsx
// ✅ Good - Complex state logic with useReducer
const initialState = { count: 0, error: null, loading: false };

const counterReducer = (state, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return { ...state, count: state.count + 1 };
    case 'SET_ERROR':
      return { ...state, error: action.payload };
    default:
      return state;
  }
};

const Counter = () => {
  const [state, dispatch] = useReducer(counterReducer, initialState);
  // Component logic
};
```

### Global State Management
- **Context API**: For theme, user authentication, simple global state
- **Redux Toolkit**: For complex applications with extensive state logic
- **Zustand/Jotai**: For lightweight state management alternatives

## Performance Optimization

### Memoization
```jsx
// ✅ Good - Memoize expensive components
const ExpensiveComponent = React.memo(({ data, config }) => {
  const processedData = useMemo(() => {
    return data.map(item => processItem(item, config));
  }, [data, config]);

  return <div>{/* Render processed data */}</div>;
});

// ✅ Good - Memoize callback functions
const ParentComponent = () => {
  const [items, setItems] = useState([]);
  
  const handleItemClick = useCallback((id) => {
    setItems(prev => prev.filter(item => item.id !== id));
  }, []);

  return (
    <div>
      {items.map(item => (
        <ChildComponent 
          key={item.id} 
          item={item} 
          onClick={handleItemClick}
        />
      ))}
    </div>
  );
};
```

### Lazy Loading
```jsx
// ✅ Good - Code splitting with lazy loading
const LazyComponent = React.lazy(() => import('./LazyComponent'));

const App = () => (
  <Suspense fallback={<div>Loading...</div>}>
    <LazyComponent />
  </Suspense>
);
```

### Performance Monitoring
- Use React DevTools Profiler
- Monitor bundle size with webpack-bundle-analyzer
- Implement performance metrics tracking

## Code Quality & Standards

### TypeScript Integration
```tsx
// ✅ Good - Proper TypeScript usage
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}

interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
}

const UserService = {
  async getUser(id: string): Promise<ApiResponse<User>> {
    const response = await fetch(`/api/users/${id}`);
    return response.json();
  }
};
```

### ESLint and Prettier Configuration
```json
// .eslintrc.json
{
  "extends": [
    "react-app",
    "react-app/jest",
    "@typescript-eslint/recommended"
  ],
  "rules": {
    "react-hooks/exhaustive-deps": "warn",
    "react/prop-types": "off",
    "no-unused-vars": "error"
  }
}
```

### Code Organization
- **Custom Hooks**: Extract logic into reusable hooks
- **Utility Functions**: Pure functions for common operations
- **Constants**: Define magic numbers and strings as constants

## Testing

### Testing Strategy
```jsx
// ✅ Good - Component testing with React Testing Library
import { render, screen, fireEvent } from '@testing-library/react';
import '@testing-library/jest-dom';
import UserCard from './UserCard';

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com'
  };

  test('renders user information correctly', () => {
    render(<UserCard user={mockUser} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  test('calls onEdit when edit button is clicked', () => {
    const mockOnEdit = jest.fn();
    render(<UserCard user={mockUser} onEdit={mockOnEdit} />);
    
    fireEvent.click(screen.getByText('Edit'));
    expect(mockOnEdit).toHaveBeenCalledWith('1');
  });
});
```

### Custom Hook Testing
```jsx
// ✅ Good - Testing custom hooks
import { renderHook, act } from '@testing-library/react';
import useCounter from './useCounter';

describe('useCounter', () => {
  test('should increment counter', () => {
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
```jsx
// ✅ Good - Sanitize user input
import DOMPurify from 'dompurify';

const SafeHTML = ({ htmlContent }) => {
  const sanitizedHTML = DOMPurify.sanitize(htmlContent);
  return <div dangerouslySetInnerHTML={{ __html: sanitizedHTML }} />;
};
```

### Environment Variables
```jsx
// ✅ Good - Secure API configuration
const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;
const API_KEY = process.env.REACT_APP_API_KEY;

// ❌ Avoid - Hardcoded sensitive data
const API_KEY = 'sk-1234567890abcdef'; // Never do this!
```

### HTTPS and Content Security Policy
- Always use HTTPS in production
- Implement proper Content Security Policy headers
- Validate and sanitize all user inputs

## Accessibility

### Semantic HTML
```jsx
// ✅ Good - Semantic and accessible
const ArticleCard = ({ article }) => (
  <article>
    <header>
      <h2>{article.title}</h2>
      <time dateTime={article.publishedAt}>{article.date}</time>
    </header>
    <p>{article.excerpt}</p>
    <footer>
      <a href={`/articles/${article.id}`} aria-label={`Read full article: ${article.title}`}>
        Read more
      </a>
    </footer>
  </article>
);
```

### ARIA Attributes
```jsx
// ✅ Good - Proper ARIA usage
const Modal = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  return (
    <div 
      role="dialog" 
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <div className="modal-content">
        <button 
          onClick={onClose}
          aria-label="Close modal"
        >
          ×
        </button>
        {children}
      </div>
    </div>
  );
};
```

### Keyboard Navigation
- Ensure all interactive elements are keyboard accessible
- Implement proper focus management
- Use appropriate ARIA roles and properties

## Deployment & Build

### Build Optimization
```json
// package.json - Build scripts
{
  "scripts": {
    "build": "react-scripts build",
    "build:analyze": "npm run build && npx webpack-bundle-analyzer build/static/js/*.js",
    "prebuild": "npm run lint && npm run test:ci"
  }
}
```

### Environment Configuration
```javascript
// ✅ Good - Environment-specific configuration
const config = {
  development: {
    apiUrl: 'http://localhost:3001/api',
    logLevel: 'debug'
  },
  production: {
    apiUrl: 'https://api.example.com',
    logLevel: 'error'
  }
}[process.env.NODE_ENV || 'development'];
```

### CI/CD Best Practices
- Automated testing in CI pipeline
- Code quality checks (ESLint, TypeScript)
- Security scanning
- Performance budgets and monitoring

## Additional Best Practices

### Error Boundaries
```jsx
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

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

### Custom Hooks Pattern
```jsx
// ✅ Good - Reusable custom hook
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

## Conclusion

Following these React best practices will help you build maintainable, performant, and scalable applications. Remember to:

- Keep components small and focused
- Use TypeScript for better type safety
- Implement proper testing strategies
- Optimize for performance and accessibility
- Follow security best practices
- Maintain consistent code quality standards

Regular code reviews and staying updated with React's evolving ecosystem are crucial for maintaining high-quality React applications.