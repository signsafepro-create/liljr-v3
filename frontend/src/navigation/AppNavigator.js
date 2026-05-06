import React from 'react';
import { Text } from 'react-native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import HomeScreen from '../screens/HomeScreen';
import ChatScreen from '../screens/ChatScreen';
import PricingScreen from '../screens/PricingScreen';
import BrainScreen from '../screens/BrainScreen';
import ProfileScreen from '../screens/ProfileScreen';
import VisionScreen from '../screens/VisionScreen';
import ScopesScreen from '../screens/ScopesScreen';
import TradingScreen from '../screens/TradingScreen';
import SocialScreen from '../screens/SocialScreen';
import SecurityScreen from '../screens/SecurityScreen';
import SettingsScreen from '../screens/SettingsScreen';
import SignSafeScreen from '../screens/SignSafeScreen';
import OneBrainHandoffScreen from '../screens/OneBrainHandoffScreen';
import VoiceChatScreen from '../screens/VoiceChatScreen';
import { THEME } from '../config/theme';

const Tab = createBottomTabNavigator();

export default function AppNavigator() {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarStyle: { backgroundColor: THEME.surface, borderTopColor: THEME.surfaceLight },
        tabBarActiveTintColor: THEME.primary,
        tabBarInactiveTintColor: THEME.textMuted
      }}
    >
      <Tab.Screen name="Home" component={HomeScreen} options={{ tabBarIcon: () => <Text>🏠</Text> }} />
      <Tab.Screen name="Chat" component={ChatScreen} options={{ tabBarIcon: () => <Text>💬</Text> }} />
      <Tab.Screen name="Voice" component={VoiceChatScreen} options={{ tabBarIcon: () => <Text>🎤</Text> }} />
      <Tab.Screen name="Vision" component={VisionScreen} options={{ tabBarIcon: () => <Text>👁️</Text> }} />
      <Tab.Screen name="Scopes" component={ScopesScreen} options={{ tabBarIcon: () => <Text>📡</Text> }} />
      <Tab.Screen name="Trading" component={TradingScreen} options={{ tabBarIcon: () => <Text>📈</Text> }} />
      <Tab.Screen name="Social" component={SocialScreen} options={{ tabBarIcon: () => <Text>🌐</Text> }} />
      <Tab.Screen name="Security" component={SecurityScreen} options={{ tabBarIcon: () => <Text>🔒</Text> }} />
      <Tab.Screen name="Settings" component={SettingsScreen} options={{ tabBarIcon: () => <Text>⚙️</Text> }} />
      <Tab.Screen name="Pricing" component={PricingScreen} options={{ tabBarIcon: () => <Text>💎</Text> }} />
      <Tab.Screen name="Brain" component={BrainScreen} options={{ tabBarIcon: () => <Text>🧠</Text> }} />
      <Tab.Screen name="Profile" component={ProfileScreen} options={{ tabBarIcon: () => <Text>👤</Text> }} />
      <Tab.Screen name="SignSafe" component={SignSafeScreen} options={{ tabBarIcon: () => <Text>📝</Text> }} />
      <Tab.Screen name="OneBrain" component={OneBrainHandoffScreen} options={{ tabBarIcon: () => <Text>🧬</Text> }} />
    </Tab.Navigator>
  );
}
