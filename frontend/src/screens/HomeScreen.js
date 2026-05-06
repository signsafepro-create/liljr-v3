import React from 'react';
import NeuralBrain from '../components/NeuralBrain';
import HomeVoiceControl from '../components/HomeVoiceControl';
import UpdateButton from '../components/UpdateButton';
import LiveTerminal from '../components/LiveTerminal';
import { View, Text, TouchableOpacity, StyleSheet, ScrollView } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';

export default function HomeScreen({ navigation }) {
  return (
    <ScrollView style={styles.scroll} contentContainerStyle={styles.container}>
      <NeuralBrain />

      <Text style={styles.logo}>LIL JR 2.0</Text>
      <Text style={styles.tagline}>Your autonomous best friend.</Text>
      <Text style={styles.tagline2}>Never sleeps. Never forgets. Always hustles.</Text>

      {/* Voice Control UI embedded for instant access */}
      <HomeVoiceControl />

      {/* Update Button for OTA updates */}
      <UpdateButton />

      {/* Live Terminal for voice-to-code and redeploy */}
      <LiveTerminal />

      <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('Voice')}>
        <LinearGradient colors={['#00f0ff', '#b829dd']} style={styles.gradient}>
          <Text style={styles.buttonText}>🎤 VOICE CHAT</Text>
        </LinearGradient>
      </TouchableOpacity>

      <TouchableOpacity style={styles.button} onPress={() => navigation.navigate('Chat')}>
        <LinearGradient colors={['#b829dd', '#00f0ff']} style={styles.gradient}>
          <Text style={styles.buttonText}>💬 START TALKING</Text>
        </LinearGradient>
      </TouchableOpacity>

      {/* Quick access grid */}
      <View style={styles.newGrid}>
        <TouchableOpacity style={styles.newBtn} onPress={() => navigation.navigate('Vision')}>
          <Text style={styles.newBtnText}>👁️ Vision</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.newBtn} onPress={() => navigation.navigate('Scopes')}>
          <Text style={styles.newBtnText}>📡 Scopes</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.newBtn} onPress={() => navigation.navigate('Trading')}>
          <Text style={styles.newBtnText}>📈 Trading</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.newBtn} onPress={() => navigation.navigate('Social')}>
          <Text style={styles.newBtnText}>🌐 Social</Text>
        </TouchableOpacity>
      </View>

      <TouchableOpacity style={[styles.button, styles.secondary]} onPress={() => navigation.navigate('Pricing')}>
        <Text style={styles.secondaryText}>💎 UPGRADE POWER</Text>
      </TouchableOpacity>

      <TouchableOpacity style={[styles.button, styles.tertiary]} onPress={() => navigation.navigate('SignSafe')}>
        <Text style={styles.tertiaryText}>📝 SIGNSAFE CANADA</Text>
      </TouchableOpacity>

      <TouchableOpacity style={[styles.button, styles.quaternary]} onPress={() => navigation.navigate('Brain')}>
        <Text style={styles.quaternaryText}>🧠 CORE BRAIN</Text>
      </TouchableOpacity>

      <TouchableOpacity style={[styles.button, styles.handoff]} onPress={() => navigation.navigate('OneBrain')}>
        <Text style={styles.handoffText}>🧬 ONE BRAIN HANDOFF</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  scroll: { flex: 1, backgroundColor: '#050508' },
  container: {
    alignItems: 'center',
    padding: 24,
    paddingBottom: 40
  },
  logo: {
    fontSize: 42,
    fontWeight: '900',
    color: '#00f0ff',
    marginBottom: 8,
    letterSpacing: 2
  },
  tagline: {
    fontSize: 16,
    color: '#b829dd',
    marginBottom: 4
  },
  tagline2: {
    fontSize: 12,
    color: '#666',
    marginBottom: 24
  },
  button: {
    width: '100%',
    maxWidth: 300,
    marginVertical: 8,
    borderRadius: 12,
    overflow: 'hidden'
  },
  gradient: {
    padding: 18,
    alignItems: 'center'
  },
  buttonText: {
    color: '#000',
    fontWeight: '900',
    fontSize: 16,
    letterSpacing: 1
  },
  secondary: {
    borderWidth: 2,
    borderColor: '#b829dd',
    padding: 16,
    alignItems: 'center'
  },
  secondaryText: {
    color: '#b829dd',
    fontWeight: '800',
    fontSize: 16
  },
  tertiary: {
    borderWidth: 1,
    borderColor: '#00f0ff',
    padding: 14,
    alignItems: 'center'
  },
  tertiaryText: {
    color: '#00f0ff',
    fontWeight: '700',
    fontSize: 14
  },
  quaternary: {
    borderWidth: 1,
    borderColor: '#ff2a6d',
    padding: 12,
    alignItems: 'center'
  },
  quaternaryText: {
    color: '#ff2a6d',
    fontWeight: '700',
    fontSize: 14
  },
  handoff: {
    borderWidth: 1,
    borderColor: '#64ff8f',
    padding: 12,
    alignItems: 'center'
  },
  handoffText: {
    color: '#64ff8f',
    fontWeight: '700',
    fontSize: 14
  },
  newGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'center',
    gap: 8,
    marginVertical: 12,
    width: '100%',
    maxWidth: 300
  },
  newBtn: {
    width: '47%',
    backgroundColor: '#0a0a12',
    borderWidth: 1,
    borderColor: '#1a1a2e',
    borderRadius: 12,
    padding: 12,
    alignItems: 'center'
  },
  newBtnText: {
    color: '#00f0ff',
    fontWeight: '700',
    fontSize: 12
  },
});
