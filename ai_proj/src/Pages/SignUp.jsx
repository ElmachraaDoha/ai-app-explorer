import { useState } from "react";
import { Link } from "react-router-dom";

const css = `
  @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Inter:wght@300;400;500&display=swap');

  /* ROOT */
  .auth-root {
    min-height: 100vh;
    background: #0d0f1a;
    font-family: Inter, sans-serif;
    color: #e2e8f0;
    display: flex;
    flex-direction: column;
  }

  /* BACKGROUND */
  .auth-bg {
    position: fixed;
    inset: 0;
    background:
      radial-gradient(ellipse 80% 50% at 20% 20%, rgba(79,70,229,0.18), transparent 60%),
      radial-gradient(ellipse 60% 40% at 80% 80%, rgba(16,185,129,0.12), transparent 60%),
      #0d0f1a;
  }

  /* HEADER */
  .auth-header {
    position: relative;
    z-index: 10;
    padding: 1.5rem 2rem;
  }

  .auth-logo {
    font-family: Syne, sans-serif;
    font-weight: 800;
    font-size: 1.2rem;
    color: #fff;
    text-decoration: none;
  }

  .auth-logo span {
    color: #6366f1;
  }

  /* CONTENT */
  .auth-content {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    z-index: 10;
    padding: 2rem;
  }

  .auth-card {
    width: 420px;
    padding: 2.5rem;
    border-radius: 16px;
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.08);
    backdrop-filter: blur(12px);
    animation: fadeUp 0.6s ease both;
  }

  .auth-title {
    font-family: Syne, sans-serif;
    font-size: 2rem;
    font-weight: 710;
    color: #fff;
    margin-bottom: 0.5rem;
  }

  .auth-sub {
    color: #94a3b8;
    font-size: 0.9rem;
    margin-bottom: 2rem;
  }

  .auth-input {
    width: 100%;
    padding: 0.85rem 1rem;
    margin-bottom: 1rem;
    border-radius: 10px;
    border: 1px solid rgba(255,255,255,0.12);
    background: rgba(0,0,0,0.25);
    color: #fff;
    outline: none;
    font-size: 0.9rem;
  }

  .auth-input:focus {
    border-color: #6366f1;
    box-shadow: 0 0 0 3px rgba(99,102,241,0.2);
  }

  .auth-btn {
    width: 100%;
    padding: 0.9rem;
    border-radius: 10px;
    border: none;
    background: #6366f1;
    color: #fff;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s;
  }

  .auth-btn:hover {
    background: #4f46e5;
    transform: translateY(-2px);
  }

  .auth-footer {
    position: relative;
    z-index: 10;
    border-top: 1px solid rgba(255,255,255,0.06);
    padding: 1.5rem;
    text-align: center;
    font-size: 0.85rem;
    color: #64748b;
  }

  .auth-switch {
    margin-top: 1rem;
    font-size: 0.85rem;
    color: #94a3b8;
    text-align: center;
  }

  .auth-link {
    color: #6366f1;
    text-decoration: none;
    transition: 0.2s;
    font-weight: 500;
  }

  .auth-link:hover {
    color: #a5b4fc;
    text-decoration: underline;
  }

  .auth-error {
    color: #f87171;
    font-size: 0.85rem;
    margin-bottom: 1rem;
  }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }
`;
export default function SignUp() {
  const [error, setError] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();

    const email = e.target.email.value;
    const password = e.target.password.value;
    const confirm = e.target.confirm.value;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // ✅ NEW PASSWORD RULE
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

    if (!emailRegex.test(email)) {
      setError("Invalid email format");
      return;
    }

    if (!passwordRegex.test(password)) {
      setError("Password must be at least 8 chars, include letters and numbers");
      return;
    }

    if (password !== confirm) {
      setError("Passwords do not match");
      return;
    }

    setError("");

    // backend call later
  };

  return (
    <div className="auth-root">
      <style>{css}</style>

      <div className="auth-bg" />

      <header className="auth-header">
        <Link to="/" className="auth-logo">
          AI <span>Radar</span>
        </Link>
      </header>

      <div className="auth-content">
        <div className="auth-card">
          <h1 className="auth-title">Create account</h1>
          <p className="auth-sub">
            Join AI Radar and explore AI tools.
          </p>

          <form onSubmit={handleSubmit}>
            <input className="auth-input" type="text" name="name" placeholder="Full name" />
            <input className="auth-input" type="email" name="email" placeholder="Email" />

            <input className="auth-input" type="password" name="password" placeholder="Password" />
            <input className="auth-input" type="password" name="confirm" placeholder="Confirm password" />

            {error && <div className="auth-error">{error}</div>}

            <button className="auth-btn" type="submit">
              Sign up
            </button>

            <div className="auth-switch">
              Already have an account?{" "}
              <Link to="/login" className="auth-link">
                Sign in
              </Link>
            </div>
          </form>
        </div>
      </div>

      <footer className="auth-footer">
        <div>AI Radar • Explore the future of AI tools</div>
      </footer>
    </div>
  );
}