import {
  NativeModulesProxy,
  EventEmitter,
  Subscription,
} from "expo-modules-core";

// Import the native module. On web, it will be resolved to AppleWallet.web.ts
// and on native platforms to AppleWallet.ts
import { ChangeEventPayload, AppleWalletViewProps } from "./AppleWallet.types";
import AppleWalletModule from "./AppleWalletModule";
import AppleWalletView from "./AppleWalletView";

// Get the native constant value.
export const PI = AppleWalletModule.PI;

export function hello(): string {
  return AppleWalletModule.hello();
}

export async function setValueAsync(value: string) {
  return await AppleWalletModule.setValueAsync(value);
}

export async function isAvailableToAddCardInAppleWallet(serialNumber: string) {
  return AppleWalletModule.isAvailableToAddCardInAppleWallet(serialNumber);
}

export async function isWalletAvailable(): Promise<boolean> {
  return AppleWalletModule.isWalletAvailable();
}

export function isCardAlreadyExists(serialNumber: string): boolean {
  return AppleWalletModule.isCardAlreadyExists(serialNumber);
}
export function isOpenPaymentSetup() {
  return AppleWalletModule.isOpenPaymentSetup();
}

export function testeViewController() {
  return AppleWalletModule.testeViewController();
}

// export function initEnrollProcess(cardHolder: string, panTokenSuffix: string) {
//   return AppleWalletModule.initEnrollProcess(cardHolder, panTokenSuffix);
// }

const emitter = new EventEmitter(
  AppleWalletModule ?? NativeModulesProxy.AppleWallet,
);

export function addChangeListener(
  listener: (event: ChangeEventPayload) => void,
): Subscription {
  return emitter.addListener<ChangeEventPayload>("onChange", listener);
}

export { AppleWalletView, AppleWalletViewProps, ChangeEventPayload };
