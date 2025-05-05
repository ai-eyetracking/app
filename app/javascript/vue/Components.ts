import Greeting from './components/Greeting.vue'
import TopBar from './components/navigation/TopBar.vue'

const components = {
  'Greeting': Greeting,
  "TopBar": TopBar,
}

export function getComponent(name) {
  console.log!("mounting", name)
  return components[name]
}