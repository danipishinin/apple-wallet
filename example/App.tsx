import * as AppleWallet from "apple-wallet";
import { useEffect, useState } from "react";
import { Button, StyleSheet, Text, View } from "react-native";
//AppleWallet.isWalletAvailable() == true
export default function App() {
  const [hasCard, setHasCard] = useState(false);
  useEffect(() => {
    AppleWallet.isAvailableToAddCardInAppleWallet("112345").then((result) => {
      setHasCard(result);
    });
  }, []);
  return (
    <View style={styles.container}>
      <Text>{AppleWallet.hello()}</Text>
      {hasCard && (
        <>
          <Button
            onPress={() => {
              AppleWallet.isOpenPaymentSetup();
            }}
            title="isAvailableToAddCardInAppleWallet"
          />
          {AppleWallet.AppleWalletView({ name: "AppleWalletView" })}
        </>
      )}
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
