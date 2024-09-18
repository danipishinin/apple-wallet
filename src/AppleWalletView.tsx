import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { AppleWalletViewProps } from './AppleWallet.types';

const NativeView: React.ComponentType<AppleWalletViewProps> =
  requireNativeViewManager('AppleWallet');

export default function AppleWalletView(props: AppleWalletViewProps) {
  return <NativeView {...props} />;
}
