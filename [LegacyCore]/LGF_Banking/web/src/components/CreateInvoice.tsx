import React, { useState } from "react";
import {
  Card,
  Title,
  Text,
  TextInput,
  NumberInput,
  Select,
  Checkbox,
  Button,
  Divider,
  Transition,
} from "@mantine/core";
import { IconPlus, IconUser, IconFileDollar, IconLibrary, IconFileInvoice } from "@tabler/icons-react";
import { fetchNui } from "../utils/fetchNui";

type Player = {
  id: number;
  name: string;
};

const CreateInvoice: React.FC<{ visible: boolean }> = ({ visible }) => {
  const [players, setPlayers] = useState<Player[]>([]);
  const [newInvoice, setNewInvoice] = useState<{
    playerId: string;
    amount: number | undefined;
    invoiceType: string;
    description: string;
    confirmed: boolean;
  }>({
    playerId: "",
    amount: undefined,
    invoiceType: "Personal",
    description: "",
    confirmed: false,
  });

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setNewInvoice((prev) => ({ ...prev, [name]: value }));
  };

  const handleCheckboxChange = (value: boolean) => {
    setNewInvoice((prev) => ({ ...prev, confirmed: value }));
  };

  const handleSelectChange = (value: string) => {
    setNewInvoice((prev) => ({ ...prev, invoiceType: value }));
  };

  const handlePlayerSelectChange = (value: string | null) => {
    setNewInvoice((prev) => ({ ...prev, playerId: value || "" }));
  };

  const handleSubmit = async () => {

    await fetchNui("LGF_Banking.CreateNewInvoice", {
      PlayerID: newInvoice.playerId,
      Amount: newInvoice.amount,
      InvoiceType: newInvoice.invoiceType,
      Description: newInvoice.description,
      Confirmed: newInvoice.confirmed,
    });

    
    setTimeout(() => {
        setNewInvoice({
          playerId: "",
          amount: undefined,
          invoiceType: "Personal",
          description: "",
          confirmed: false,
        });
      }, 2000);
  };

  const getNearbyPlayers = async () => {
    try {
      const response = await fetchNui("LGF_Banking.GetclosestPlayer");
      if (Array.isArray(response)) {
        const fetchedPlayers = response.map((player) => ({
          id: player.PlayerId,
          name: player.PlayerName ? `${player.PlayerName} (${player.PlayerId})` : player.PlayerId.toString(),
        }));
        setPlayers(fetchedPlayers);
      } else {
        console.error("Unexpected response format", response);
      }
    } catch (error) {
      console.error("Failed to fetch closest players", error);
    }
  };

  return (
    <Transition transition="fade" duration={300} mounted={visible}>
      {(styles) => (
        <Card
          padding="lg"
          withBorder
          shadow="md"
          style={{ width: 400, margin: "auto", marginTop: "200px", ...styles }}
        >
          <Title order={4} style={{ marginBottom: "5px" }}>
            <IconPlus size={24} style={{ verticalAlign: "middle", marginRight: "10px" }} />
            Create New Invoice
          </Title>
          <Text size="sm" color="dimmed" style={{ marginBottom: "15px" }}>
            Create and manage new invoices easily.
          </Text>
          <form onSubmit={(e) => { e.preventDefault(); handleSubmit(); }}>
            <Select
              required
              label="Select Player ID"
              name="playerId"
              value={newInvoice.playerId}
              onChange={handlePlayerSelectChange}
              clearable
              onDropdownOpen={getNearbyPlayers}
              data={players.map((player) => ({
                value: player.id.toString(),
                label: `${player.id} - ${player.name}`,
              }))}
              description="Select the unique ID of the player."
              style={{ marginBottom: "15px" }}
              icon={<IconUser size={16} />}
            />
            <NumberInput
              required
              label="Enter Amount"
              name="amount"
              value={newInvoice.amount}
              onChange={(value) => setNewInvoice((prev) => ({ ...prev, amount: value === "" ? undefined : value }))}
              placeholder="1500"
              description="The amount for the invoice (e.g., in USD)."
              style={{ marginBottom: "15px" }}
              icon={<IconFileDollar size={16} />}
            />
            <Select
              required
              label="Select Invoice Type"
              name="invoiceType"
              value={newInvoice.invoiceType}
              onChange={handleSelectChange}
              icon={<IconFileInvoice size={16} />}
              data={[
                { value: "Personal", label: "Personal" },
                { value: "Society", label: "Society" },
              ]}
              description="Choose the type of the invoice."
              style={{ marginBottom: "15px" }}
            />
            <TextInput
              required
              label="Enter Description"
              name="description"
              value={newInvoice.description}
              onChange={handleInputChange}
              placeholder="Briefly describe the invoice."
              style={{ marginBottom: "15px" }}
              icon={<IconLibrary size={16} />}
            />
            <Divider my="xs" label="Confirmation" labelPosition="center" />
            <Checkbox
              label="Confirm"
              description="Confirm creation of the invoice"
              checked={newInvoice.confirmed}
              required
              onChange={(event) => handleCheckboxChange(event.currentTarget.checked)}
              style={{ marginBottom: "10px" }}
            />
            <Button leftIcon={<IconPlus size={16} />} variant="light" color="indigo" type="submit" fullWidth>
              Create Invoice
            </Button>
          </form>
        </Card>
      )}
    </Transition>
  );
};

export default CreateInvoice;
