import { Button, StyleSheet, Text, View } from "react-native";

import * as AppleWallet from "apple-wallet";
import { useState } from "react";

export default function App() {
  const [isCompatible, setIsCompatible] = useState(false);
  const [canAddCard, setCanAddCard] = useState(false);
  return (
    <View style={styles.container}>
      <Text>{AppleWallet.hello()}</Text>
      <Text>Dispositivo é compatível com a Wallet?</Text>
      <Button
        onPress={async () => {
          await AppleWallet.isDeviceEligibleForAppleWallet().then((r) => {
            setIsCompatible(r);
          }).catch((e) => console.log("deu ruim ne", e));
        }}
        title="Checar"
      />
      <Text>{isCompatible ? "Sim" : "Não"}</Text>

      <Text>Posso adicionar cartões na wallet?</Text>
      <Button
        onPress={async () => {
          await AppleWallet.canAddCardOnWallet().then((r) => {
            setCanAddCard(r);
          }).catch((e) => console.log("deu ruim ne", e));
        }}
        title="Checar"
      />
      <Text>{canAddCard ? "Sim" : "Não"}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
