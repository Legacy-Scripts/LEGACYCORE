import React, { useState } from "react";
import { fetchNui } from "../utils/fetchNui";
import { Button, Loader, PasswordInput, Text } from "@mantine/core"; // Import necessary components from Mantine
import { IconLock, IconKey, IconCheck, IconShieldLock, IconFingerprint } from "@tabler/icons-react"; // Import icons for the inputs
import "./pinAccess.scss"; // Import your SCSS styles

interface PinAccessProps {
  visible: boolean;
  isNew: boolean; // true for creating a new PIN, false for entering an existing PIN
}

const PinAccess: React.FC<PinAccessProps> = ({ visible, isNew }) => {
  const [pin, setPin] = useState<string>("");
  const [confirmPin, setConfirmPin] = useState<string>("");
  const [error, setError] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false); // Loading state

  const handleSubmit = async () => {
    if (isNew) {
      if (pin !== confirmPin) {
        setError("PINs do not match!");
        setTimeout(() => setError(""), 3000);
        return;
      }
    }

    setLoading(true);

    try {
      if (isNew) {
        await fetchNui("LGF_Banking.PinSetted", { pin: pin, new: true });
      } else {
        await fetchNui("LGF_Banking.PinSetted", { pin: pin, new: false });
      }
      clearCache();
    } catch (err) {
      setError("An error occurred, please try again.");
      setTimeout(() => setError(""), 3000);
    } finally {
      setLoading(false);
    }
  };

  const clearCache = () => {
    setPin("");
    setError("");
    setConfirmPin("");
    setLoading(false);
  };

  return (
    <div className={`pinContainer ${visible ? "slide-in" : "slide-out"}`}>
      <h2 style={{ display: 'flex', alignItems: 'center' }}>
        <IconShieldLock size={24} style={{ marginRight: '8px' }} />
        {isNew ? "Create New PIN" : "Enter Your PIN"}
      </h2>
      <div className="inputContainer">
        <PasswordInput
          description={
            isNew
              ? "Please create a new PIN for your account."
              : "Enter your existing PIN to access your account."
          }
          placeholder="Enter PIN"
          value={pin}
          onChange={(e) => setPin(e.currentTarget.value)}
          maxLength={4}
          required
          label="PIN"
          icon={<IconLock size={16} />}
        />
        {isNew && (
          <PasswordInput
            mb={20}
            description="Please re-enter your PIN to confirm."
            placeholder="Confirm PIN"
            value={confirmPin}
            onChange={(e) => setConfirmPin(e.currentTarget.value)}
            maxLength={4}
            required
            label="Confirm PIN"
            icon={<IconKey size={16} />}
            mt="md"
          />
        )}
      </div>
      {error && <p className="error">{error}</p>}
      {/* Display Loader outside the button */}
      {loading && (
        <Loader variant="dots" color="white" size="lg" style={{ marginBottom: "10px" }} />
      )}
      {/* Fingerprint icon for existing PIN */}
      {!isNew && (
        <div style={{ 
          display: 'flex', 
          flexDirection: 'column', // Stack vertically
          alignItems: 'center', // Center horizontally
          marginTop: '20px' // Add some margin to separate from other elements
        }}>
          <Text color="dimmed" size="md" style={{ marginBottom: '10px' }}>Tap To Login</Text>
          <IconFingerprint
            stroke={1}
            size={60}
            style={{
              cursor: "pointer",
              color: "gray",
              transition: "color 0.3s",
            }}
            onMouseEnter={(e) => (e.currentTarget.style.color = "#cbd5e1")} // Change color on hover
            onMouseLeave={(e) => (e.currentTarget.style.color = "gray")} // Reset color on mouse leave
            onClick={handleSubmit} // Submit PIN on click
          />
        </div>
      )}
      {/* Only show the button if creating a new PIN */}
      {isNew && (
        <Button
          onClick={handleSubmit}
          variant="light"
          color="red"
          size="sm"
          mb={10}
          disabled={loading}
          leftIcon={<IconCheck size={16} />} // Add an icon to the button
        >
          Create PIN
        </Button>
      )}
    </div>
  );
};

export default PinAccess;
