// importing routing library 
import { createBrowserRouter } from 'react-router-dom';

// importing Layouts
import AdminLayout from "../Layouts/AdminLayout.jsx";
import UserLayout from "../Layouts/UserLayout.jsx";

// importing Pages
import Landing from "../Pages/Landing.jsx";
import Dashboard from "../Pages/Dashboard.jsx";
import History from "../Pages/history.jsx";
import App_details from "../Pages/App_details.jsx"; 
import SignUp from "../Pages/SignUp.jsx";
import Login from "../Pages/Login.jsx";
import Library from "../Pages/Library.jsx"; 
import Submit_app from "../Pages/Submit_app.jsx";
import AIndex from "../Pages/AIndex.jsx"; 

// routing
const router = createBrowserRouter([
  {
    path: "/",
    element: <UserLayout />,
    children: [
      { index: true, element: <Landing /> },
      { path: "dashboard", element: <Dashboard /> },
      { path: "app_details", element: <App_details /> },
      { path: "history", element: <History /> },
      { path: "library", element: <Library /> },
      { path: "submit_app", element: <Submit_app /> },
      { path: "login", element: <Login /> },
      { path: "signUp", element: <SignUp /> },
    ]
  },
  {
    path: "/admin",
    element: <AdminLayout />,
    children: [
      { index: true, element: <AIndex /> }, 
    ]
  }
]);

export default router;