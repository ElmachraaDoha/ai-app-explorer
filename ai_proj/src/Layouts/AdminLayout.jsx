import Header from '../Components/Header.jsx';
import Footer from '../Components/Footer.jsx';
import { Outlet } from 'react-router-dom';

function AdminLayout() {
  return (
    <>
      <Header />

      <main>
        <Outlet />
      </main>

      <Footer />
    </>
  );
}

export default AdminLayout;