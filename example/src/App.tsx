import { StyleSheet, View } from 'react-native';
import { IosGlurViewView } from 'react-native-ios-glur-view';

export default function App() {
  return (
    <View style={styles.container}>
      <IosGlurViewView
        useGlur
        glurRadius={25}
        glurOffset={0.3}
        glurInterpolation={0.35}
        glurDirection="down"
        glurNoise={0.01}
        glurDrawingGroup
        tintOpacity={1}
        imageUri="https://images.unsplash.com/photo-1761438180295-9ea187978263?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1964"
        style={styles.box}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'red',
  },
  box: {
    width: '50%',
    height: '50%',
    marginVertical: 20,
  },
});
