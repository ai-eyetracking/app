import Greeting from './components/Greeting.vue'
import TopBar from './components/navigation/TopBar.vue'
import SideNav from './components/navigation/SideNav.vue'
import ProjectGrid from './components/dashboard/ProjectGrid.vue'

const components = {
  'Greeting': Greeting,
  "TopBar": TopBar,
  "SideNav": SideNav,
  "ProjectGrid": ProjectGrid, 
}

export function getComponent(name) {
  console.log!("mounting", name)
  return components[name]
}