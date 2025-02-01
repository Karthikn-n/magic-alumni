import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
// import Breadcrumb from '../../components/Breadcrumbs/Breadcrumb';
import LogoDark from '../../images/logo/logo-dark.svg';
import Logo from '../../images/logo/logo.svg';

interface Errors {
  name?: string;
  address?: string;
  city?: string;
  password?: string;
  confirmPassword?: string;
  form?: string;
}

const SignUp: React.FC = () => {
  const [formData, setFormData] = useState({
    name: '',
    address: '',
    city: '',
    password: '',
    confirmPassword: '',
    description: '',
  });

  const [errors, setErrors] = useState<Errors>({});
  const [success, setSuccess] = useState('');
  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const { name, address, password, confirmPassword, city, description } =
      formData;

    let validationErrors: Errors = {};

    if (!name) validationErrors.name = 'College name is required';
    if (!address) validationErrors.address = 'Address is required';
    if (!city) validationErrors.city = 'City is required';
    if (!password) validationErrors.password = 'Password is required';
    if (password !== confirmPassword)
      validationErrors.confirmPassword = 'Passwords do not match';

    if (Object.keys(validationErrors).length > 0) {
      return setErrors(validationErrors);
    }

    try {
      setErrors({});
      setSuccess('');
      const response = await fetch(
        'http://localhost:3000/api/colleges/register',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            name,
            address,
            city,
            password,
            confirmPassword,
            description,
          }),
        },
      );

      const result = await response.json();

      if (response.ok) {
        setSuccess('Account created successfully!');
        setTimeout(() => navigate('/'), 2000);
      } else {
        setErrors({ form: result.message || 'Error creating account.' });
      }
    } catch (err) {
      setErrors({ form: 'Something went wrong. Please try again.' });
    }
  };

  return (
    <>
      {/* <Breadcrumb pageName="Sign Up" /> */}

      <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div className="flex flex-wrap items-center">
          <div className="hidden w-full xl:block xl:w-1/2">
            <div className="py-17.5 px-26 text-center">
              <Link className="mb-5.5 inline-block" to="/">
                <img className="hidden dark:block" src={Logo} alt="Logo" />
                <img className="dark:hidden" src={LogoDark} alt="Logo" />
              </Link>
              <p className="2xl:px-20">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit
                suspendisse.
              </p>
            </div>
          </div>

          <div className="w-full border-stroke dark:border-strokedark xl:w-1/2 xl:border-l-2">
            <div className="w-full p-4 sm:p-12.5 xl:p-17.5">
              <h2 className="mb-9 text-2xl font-bold text-black dark:text-white sm:text-title-xl2">
                Sign Up to TailAdmin
              </h2>

              <form onSubmit={handleSubmit}>
                {errors.form && (
                  <p className="mb-4 text-red-500">{errors.form}</p>
                )}

                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    College Name
                  </label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    placeholder="Enter college name"
                    className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black dark:border-form-strokedark dark:bg-form-input dark:text-white"
                  />
                  {errors.name && (
                    <p className="text-red-500 text-sm">{errors.name}</p>
                  )}
                </div>

                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    Address
                  </label>
                  <input
                    type="textarea"
                    name="address"
                    value={formData.address}
                    onChange={handleChange}
                    placeholder="Enter your address"
                    className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black dark:border-form-strokedark dark:bg-form-input dark:text-white"
                  />
                  {errors.address && (
                    <p className="text-red-500 text-sm">{errors.address}</p>
                  )}
                </div>

                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    City
                  </label>
                  <input
                    type="text"
                    name="city"
                    value={formData.city}
                    onChange={handleChange}
                    placeholder="Enter your city"
                    className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black dark:border-form-strokedark dark:bg-form-input dark:text-white"
                  />
                  {errors.city && (
                    <p className="text-red-500 text-sm">{errors.city}</p>
                  )}
                </div>

                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    Description
                  </label>
                  <input
                    type="text"
                    name="description"
                    value={formData.description}
                    onChange={handleChange}
                    placeholder="Enter your description"
                    className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black dark:border-form-strokedark dark:bg-form-input dark:text-white"
                  />
                </div>

                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    Password
                  </label>
                  <input
                    type="password"
                    name="password"
                    value={formData.password}
                    onChange={handleChange}
                    placeholder="Enter your password"
                    className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black dark:border-form-strokedark dark:bg-form-input dark:text-white"
                  />
                  {errors.password && (
                    <p className="text-red-500 text-sm">{errors.password}</p>
                  )}
                </div>

                <div className="mb-4">
                  <label className="mb-2.5 block font-medium text-black dark:text-white">
                    Confirm Password
                  </label>
                  <input
                    type="password"
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    placeholder="Confirm your password"
                    className="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 text-black dark:border-form-strokedark dark:bg-form-input dark:text-white"
                  />
                  {errors.confirmPassword && (
                    <p className="text-red-500 text-sm">
                      {errors.confirmPassword}
                    </p>
                  )}
                </div>

                <button
                  type="submit"
                  className="w-full cursor-pointer rounded-lg border border-primary bg-primary p-4 text-white transition hover:bg-opacity-90"
                >
                  Create account
                </button>
              </form>
              <div className="mt-6 text-center">
                <p>
                  Already have an account?{' '}
                  <Link to="/" className="text-primary">
                    Sign in
                  </Link>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default SignUp;
