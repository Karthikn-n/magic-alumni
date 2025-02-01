import { useEffect, useState } from 'react';
import { Route, Routes, useLocation, Navigate } from 'react-router-dom';

import Loader from './common/Loader';
import { toast } from 'react-toastify';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import PageTitle from './components/PageTitle';
import SignIn from './pages/Authentication/SignIn';
import SignUp from './pages/Authentication/SignUp';
import Calendar from './pages/Calendar';
import Chart from './pages/Chart';
import ECommerce from './pages/Dashboard/ECommerce';
import FormElements from './pages/Form/FormElements';
import FormLayout from './pages/Form/FormLayout';
import Profile from './pages/Profile';
import Settings from './pages/Settings';
import Tables from './pages/Tables';
import Alerts from './pages/UiElements/Alerts';
import Buttons from './pages/UiElements/Buttons';
import DefaultLayout from './layout/DefaultLayout';
import Members from './pages/Member/Members';
import AddMember from './pages/Member/AddMember';
import EditMember from './pages/Member/EditMember';
import Departments from './pages/Department/Departments';
import AddDepartment from './pages/Department/AddDepartment';
import EditDepartment from './pages/Department/EditDepartment';
import Events from './pages/Event/Event';
import CreateEvent from './pages/Event/AddEvent';
import Job from './pages/Job/Job';
import AddJob from './pages/Job/AddJob';
import EditJob from './pages/Job/EditJob';
import UnApprovedEvents from './pages/UnApprovedEvents';
import EventDetails from './pages/Event/EventShow';
import UnApprovedMembers from './pages/UnApprovedMembers';
import MemberDetails from './pages/Member/MemberShow';
import NewsList from './pages/News/News';
import AddNews from './pages/News/AddNews';
import ReportJob from './pages/Job/ReportJob';

function ProtectedRoute({ children }: { children: JSX.Element }) {
  const collegeId = localStorage.getItem('collegeId');

  if (!collegeId) {
    if (!toast.isActive('signin-warning')) {
      toast.warn('Kindly sign in to access this page!', {
        toastId: 'signin-warning',
        position: 'top-center',
        autoClose: 2000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
      });
    }

    return <Navigate to="/" replace />;
  }

  return children;
}

function App() {
  const [loading, setLoading] = useState<boolean>(true);
  const { pathname } = useLocation();

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);

  useEffect(() => {
    setTimeout(() => setLoading(false), 1000);
  }, []);

  return loading ? (
    <Loader />
  ) : (
    <DefaultLayout>
      <Routes>
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="eCommerce Dashboard | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <ECommerce />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/calendar"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Calendar | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Calendar />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/members"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Members | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Members />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/add-member"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Add Members | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <AddMember />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/edit-member/:id"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Edit Members | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <EditMember />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/departments"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Departments | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Departments />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/add-department"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Departments | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <AddDepartment />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/edit-department/:id"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Edit Members | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <EditDepartment />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/events"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Events | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Events />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/add-events"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Add Events | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <CreateEvent />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/jobs"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Job | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Job />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/add-job"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Job | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <AddJob />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/edit-job/:id"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Job | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <EditJob />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/reports/:id"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Job | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <ReportJob />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/unapproved-events"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Un Approved Events | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <UnApprovedEvents />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/unapproved-members"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Un Approved Members | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <UnApprovedMembers />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/event/:id"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Un Approved Events | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <EventDetails />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/member/:id"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Un Approved Members | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <MemberDetails />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/news"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="News | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <NewsList />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/add-news"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Add News | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <AddNews />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/profile"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Profile | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Profile />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/forms/form-elements"
          element={
            <>
              <PageTitle title="Form Elements | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <FormElements />
            </>
          }
        />
        <Route
          path="/forms/form-layout"
          element={
            <>
              <PageTitle title="Form Layout | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <FormLayout />
            </>
          }
        />
        <Route
          path="/tables"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Tables | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Tables />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/settings"
          element={
            <ProtectedRoute>
              <>
                <PageTitle title="Settings | TailAdmin - Tailwind CSS Admin Dashboard Template" />
                <Settings />
              </>
            </ProtectedRoute>
          }
        />
        <Route
          path="/chart"
          element={
            <>
              <PageTitle title="Basic Chart | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <Chart />
            </>
          }
        />
        <Route
          path="/ui/alerts"
          element={
            <>
              <PageTitle title="Alerts | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <Alerts />
            </>
          }
        />
        <Route
          path="/ui/buttons"
          element={
            <>
              <PageTitle title="Buttons | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <Buttons />
            </>
          }
        />
        <Route
          path="/"
          element={
            <>
              <PageTitle title="Signin | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <SignIn />
            </>
          }
        />
        <Route
          path="/auth/signup"
          element={
            <>
              <PageTitle title="Signup | TailAdmin - Tailwind CSS Admin Dashboard Template" />
              <SignUp />
            </>
          }
        />
      </Routes>
      <ToastContainer />
    </DefaultLayout>
  );
}

export default App;
