import React, { useState, useEffect } from "react";
import {
  Container,
  Grid,
  Col,
  Title,
  Text,
  Button,
  Group,
  ThemeIcon,
  Card,
  Checkbox,
  PasswordInput,
} from "@mantine/core";
import { IconLock, IconCreditCard } from "@tabler/icons-react"; 
import Cards from "react-credit-cards-2"; 
import "react-credit-cards-2/dist/es/styles-compiled.css"; 
import { motion } from "framer-motion";
import { fetchNui } from "../utils/fetchNui";

interface CardData {
  number: string;
  expiry: string;
  cvc: string; 
  name: string;
  focus?: string; 
}

const SettingsPin: React.FC<{ visible: boolean }> = ({ visible }) => {
  const [newPin, setNewPin] = useState("");
  const [confirmPin, setConfirmPin] = useState("");
  const [confirmCheckbox, setConfirmCheckbox] = useState(false); 

  const [cardDetails, setCardDetails] = useState<CardData>({
    number: "", 
    expiry: "", 
    cvc: "",  
    name: "",   
    focus: "", 
  });

  const handleChangePin = async () => {
    if (newPin === confirmPin && confirmCheckbox) {
      setNewPin("");
      setConfirmPin("");
      setConfirmCheckbox(false);
      await fetchNui("LGF_Banking.ChangePin", {
        pin: newPin,
        changed: true,
      });
    } else {
      await fetchNui("LGF_Banking.ChangePin", {
        pin: newPin,
        changed: false,
      });
    }
  };

  const fetchCardData = async () => {
    try {

      const cardData = (await fetchNui("LGF_Banking.GetCreditCardInfo")) as CardData;
      setCardDetails({
        number: cardData.number || "", 
        expiry: cardData.expiry || "", 
        cvc: cardData.cvc || "",       
        name: cardData.name || "",      
        focus: "",                     
      });
    } catch (error) {
      console.error("Error fetching card data:", error);
    }
  };


  useEffect(() => {
    if (visible) {
      fetchCardData();
    }
  }, [visible]);

  return (
    <Container p={0} w={900}>
      <Grid gutter="md">
        <Col span={12}>
          <Title order={3} align="center" style={{ marginBottom: "5px", color: "#fff" }}>
            Manage Your Security Settings
          </Title>
          <Text mb={30} align="center" size="sm" color="dimmed">
            Update your PIN and manage your credit card information securely.
          </Text>
        </Col>


        <Col span={6}>
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.8 }}>
            <Card padding="lg" shadow="sm" withBorder style={{ backgroundColor: "transparent", color: "#fff", borderRadius: "8px", height: "400px" }}>
              <Group position="apart" align="center">
                <div>
                  <Title tt="uppercase" order={3}>
                    Change PIN
                  </Title>
                  <Text size="sm" color="dimmed" style={{ marginTop: "5px" }}>
                    Update your security PIN
                  </Text>
                </div>
                <ThemeIcon size={40} variant="outline" color="blue">
                  <IconLock size={30} stroke={1} />
                </ThemeIcon>
              </Group>

              <div style={{ marginTop: "20px" }}>
                <PasswordInput
                  label="Insert New PIN"
                  placeholder="New PIN"
                  value={newPin}
                  onChange={(e) => setNewPin(e.currentTarget.value)}
                  style={{ marginBottom: "10px" }}
                  description="Password must include at least 4 numbers."
                  withAsterisk
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
                <PasswordInput
                  label="Confirm New PIN"
                  description="Confirm the Current New Pin"
                  placeholder="Confirm New PIN"
                  value={confirmPin}
                  onChange={(e) => setConfirmPin(e.currentTarget.value)}
                  style={{ marginBottom: "10px" }}
                  withAsterisk
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
                <Checkbox
                  label="Confirm PIN Change"
                  description="Tick this box to confirm that you want to change your PIN"
                  checked={confirmCheckbox}
                  onChange={(event) => setConfirmCheckbox(event.currentTarget.checked)}
                  style={{ marginBottom: "10px" }}
                />
                <Button variant="light" onClick={handleChangePin} color="blue" fullWidth>
                  Change PIN
                </Button>
              </div>
            </Card>
          </motion.div>
        </Col>


        <Col span={6}>
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.8 }}>
            <Card padding="lg" shadow="sm" style={{ backgroundColor: "transparent", color: "#fff", borderRadius: "8px", height: "300px" }}>
              <Group mb={25} position="apart" align="center">
                <div>
                  <Title tt="uppercase" order={3}>
                    My Credit Card
                  </Title>
                  <Text size="sm" color="dimmed" style={{ marginTop: "5px" }}>
                    My current Credit Card
                  </Text>
                </div>
                <ThemeIcon size={40} variant="outline" color="orange">
                  <IconCreditCard size={30} stroke={1} />
                </ThemeIcon>
              </Group>

              <Cards
                number={cardDetails.number}
                expiry={cardDetails.expiry}
                cvc={cardDetails.cvc}
                name={cardDetails.name}
                preview={true}
                focused={undefined} 
                issuer={"Legacy Scripts"} 
              />
            </Card>
          </motion.div>
        </Col>
      </Grid>
      
      <Container
      >
        <Group position="center">
          <Text color="dimmed" size="lg" style={{ fontWeight: 600 }}> 
            &copy; {new Date().getFullYear()} LGF_Banking. All rights reserved.
          </Text>
        </Group>
      </Container>
    </Container>
  );
};

export default SettingsPin;
