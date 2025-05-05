import Greeting from './components/Greeting.vue'
import TopBar from './components/navigation/TopBar.vue'
import SideNav from './components/navigation/SideNav.vue'

const components = {
  'Greeting': Greeting,
  "TopBar": TopBar,
  "SideNav": SideNav, 
}

export function getComponent(name) {
  console.log!("mounting", name)
  return components[name]
}