import React, { useEffect, useState } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { isEnvBrowser } from "../utils/misc";
import Banking from "./RenderPage";
import "./index.scss";
import "./pinAccess.scss";
import { Button } from "@mantine/core";
import PinAccess from "./AccessPin";
import CreateInvoice from "./CreateInvoice";

const App: React.FC = () => {
  const [bankingVisible, setBankingVisible] = useState(false);
  const [pinAccessVisible, setPinAccessVisible] = useState(false);
  const [playerData, setPlayerData] = useState({});
  const [isNew, setIsNew] = useState(false);
  const [invoiceVisible, setInvoiceVisible] = useState(false);


  useNuiEvent<any>("openBanking", (data) => {
    setBankingVisible(data.Visible);
    setPlayerData(data.PersonalData);
  });

  useNuiEvent<any>("openPinAccess", (data) => {
    setPinAccessVisible(data.Visible);
    setIsNew(data.isNew)
  });

  useNuiEvent<any>("createInvoice", (data) => {

    setInvoiceVisible(data.Visible)
  });

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (e.code === 'Escape') {
        // Close the PIN access form
        if (pinAccessVisible) {
          if (!isEnvBrowser()) {
            fetchNui('LGF_Banking:CloseByIndex', { ui_name: 'openPinAccess' });
          } else {
            setPinAccessVisible(false);
          }
        }
  

        if (invoiceVisible) {
          if (!isEnvBrowser()) {
            fetchNui('LGF_Banking:CloseByIndex', { ui_name: 'createInvoice' });
          } else {
            setInvoiceVisible(false);
          }
        }
      }
    };
  
    window.addEventListener('keydown', keyHandler);
  
    return () => {
      window.removeEventListener('keydown', keyHandler);
    };
  }, [pinAccessVisible, invoiceVisible]);

  return (
    <>
      <PinAccess visible={pinAccessVisible} isNew={isNew} />
      <Banking visible={bankingVisible} playerData={playerData} />
      <CreateInvoice visible={invoiceVisible} />
      {isEnvBrowser() && (
        <>
          <Button
            onClick={() => setPinAccessVisible(true)}
            variant="default"
            color="orange"
            style={{
              position: "fixed",
              top: 80,
              right: 10,
              zIndex: 1000,
              width: 150,
            }}
          >
            Access Pin
          </Button>
          <Button
            onClick={() => setBankingVisible(true)}
            variant="default"
            color="orange"
            style={{
              position: "fixed",
              top: 10,
              right: 10,
              zIndex: 1000,
              width: 150,
            }}
          >
            Open Bank
          </Button>
          <Button
            onClick={() => setInvoiceVisible(true)}
            variant="default"
            color="orange"
            style={{
              position: "fixed",
              top: 130,
              right: 10,
              zIndex: 1000,
              width: 150,
            }}
          >
        Create Invoice
          </Button>
        </>
      )}
    </>
  );
};

export default App;
