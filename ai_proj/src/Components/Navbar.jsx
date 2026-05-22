import { NavLink } from 'react-router-dom';
export default function Navbar() {
  return (
    <nav >
      <ul>
        <li><NavLink to="/">Home</NavLink></li>
        <li><NavLink to="/library">Library</NavLink></li>
        <li><NavLink to="/dashboard">Dashboard</NavLink></li>
        <li><NavLink to="/history">History</NavLink></li>
      </ul>
      <div >
        <NavLink to="/login" >Login</NavLink>
        <NavLink to="/signUp" >Sign Up</NavLink>
      </div>
    </nav>
  );
}