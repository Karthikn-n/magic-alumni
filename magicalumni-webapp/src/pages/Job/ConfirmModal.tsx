import React from 'react';

interface ConfirmModalProps {
  show: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

const ConfirmModal: React.FC<ConfirmModalProps> = ({
  show,
  onConfirm,
  onCancel,
}) => {
  if (!show) return null;

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-gray-500 bg-opacity-50 z-50">
      <div className="bg-white p-6 rounded-md shadow-lg">
        <h2 className="text-lg font-semibold">
          Are you sure you want to delete this job?
        </h2>
        <div className="mt-4">
          <button
            className="bg-red-500 text-white px-4 py-2 rounded-md mr-2"
            onClick={onConfirm}
          >
            Yes, Delete
          </button>
          <button
            className="bg-gray-300 text-gray-800 px-4 py-2 rounded-md"
            onClick={onCancel}
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default ConfirmModal;
