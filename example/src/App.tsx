import { View, StyleSheet } from 'react-native';
import { IosGlurViewView } from 'react-native-ios-glur-view';

export default function App() {
  return (
    <View style={styles.container}>
      <IosGlurViewView color="#32a852" style={styles.box} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
