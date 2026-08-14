



class Component extends DCLogic {
  state = { screen: 'welcome', tab: 'home', lang: 'fr', theme: 'dark', sheet: null, countryId: null, operatorId: null, plan: null, pay: 'momo' };

  constructor(props){
    super(props);
    this.globeWrapRef = React.createRef();
    this.globeCanvasRef = React.createRef();
    this.globeLabelsRef = React.createRef();
    this._globe = null;
    this._raf = null;
    this.wGlobeCanvasRef = React.createRef();
    this.wGlobeWrapRef = React.createRef();
    this._wglobe = null;
    this._wraf = null;
    this.qr = this._genQR();
  }

  _genQR(){
    const n=21, cells=[];
    const finder=(ox,oy,x,y)=>{ const dx=x-ox,dy=y-oy; if(dx<0||dy<0||dx>6||dy>6)return null; const edge=(dx===0||dx===6||dy===0||dy===6); const inner=(dx>=2&&dx<=4&&dy>=2&&dy<=4); return edge||inner; };
    let seed=97;
    const rnd=()=>{ seed=(seed*1103515245+12345)&0x7fffffff; return seed/0x7fffffff; };
    for(let y=0;y<n;y++)for(let x=0;x<n;x++){
      let f = finder(0,0,x,y); if(f===null) f=finder(n-7,0,x,y); if(f===null) f=finder(0,n-7,x,y);
      let on;
      if(f!==null) on=f;
      else if((x<8&&y<8)||(x>n-9&&y<8)||(x<8&&y>n-9)) on=false;
      else on=rnd()>0.52;
      cells.push({bg: on?'#0a1224':'transparent'});
    }
    return cells;
  }

  // ---------- DATA ----------
  countries = [
    { id:'sn', name:'Sénégal', flag:'🇸🇳', code:'sn', iso:'686', lat:14.7, lon:-14.4, cur:'XOF', ops:['orange','free','expresso'] },
    { id:'ci', name:"Côte d'Ivoire", flag:'🇨🇮', code:'ci', iso:'384', lat:7.5, lon:-5.5, cur:'XOF', ops:['orange','mtn','moov'] },
    { id:'gh', name:'Ghana', flag:'🇬🇭', code:'gh', iso:'288', lat:7.9, lon:-1.0, cur:'GHS', ops:['mtn','telecel','airtel'] },
    { id:'ng', name:'Nigeria', flag:'🇳🇬', code:'ng', iso:'566', lat:9.1, lon:8.7, cur:'NGN', ops:['mtn','airtel','glo'] },
    { id:'tg', name:'Togo', flag:'🇹🇬', code:'tg', iso:'768', lat:8.6, lon:0.8, cur:'XOF', ops:['togocom','moov'] },
    { id:'bj', name:'Bénin', flag:'🇧🇯', code:'bj', iso:'204', lat:9.5, lon:2.3, cur:'XOF', ops:['mtn','celtiis','moov'] },
    { id:'bf', name:'Burkina Faso', flag:'🇧🇫', code:'bf', iso:'854', lat:12.3, lon:-1.6, cur:'XOF', ops:['orange','moov','telecel'] },
    { id:'ml', name:'Mali', flag:'🇲🇱', code:'ml', iso:'466', lat:17.4, lon:-3.5, cur:'XOF', ops:['orange','malitel','telecel'] },
  ];
  operators = {
    mtn:{name:'MTN', c:'#FFCC00', t:'#1a1a00'},
    orange:{name:'Orange', c:'#FF7900', t:'#241000'},
    moov:{name:'Moov Africa', c:'#0a58ca', t:'#fff'},
    airtel:{name:'AirtelTigo', c:'#E4002B', t:'#fff'},
    telecel:{name:'Telecel', c:'#E4002B', t:'#fff'},
    glo:{name:'Glo', c:'#00A651', t:'#fff'},
    free:{name:'Free', c:'#E2001A', t:'#fff'},
    expresso:{name:'Expresso', c:'#F58220', t:'#241000'},
    celtiis:{name:'Celtiis', c:'#17A398', t:'#fff'},
    togocom:{name:'Togocom', c:'#E30613', t:'#fff'},
    malitel:{name:'Malitel', c:'#12B24A', t:'#fff'},
  };
  planSpecs = [
    { data:'1,5 Go', dur_fr:'24 heures', dur_en:'24 hours', tier:0 },
    { data:'6 Go', dur_fr:'7 jours', dur_en:'7 days', tier:1 },
    { data:'15 Go', dur_fr:'30 jours', dur_en:'30 days', tier:2 },
    { data:'40 Go', dur_fr:'30 jours', dur_en:'30 days', tier:2 },
  ];
  prices = { XOF:[900,3500,7900,14900], GHS:[12,45,99,180], NGN:[900,3500,8000,15000] };

  fmtPrice(cur, n){
    if(cur==='GHS') return '₵'+n;
    if(cur==='NGN') return '₦'+n.toLocaleString('en-US');
    return n.toLocaleString('fr-FR').replace(/,/g,' ')+' FCFA';
  }

  // ---------- i18n ----------
  get strings(){
    const fr = {
      badge:'DATA MOBILE · AFRIQUE', welcome_title:'Restez connecté partout en Afrique.',
      welcome_sub:'Achetez votre forfait data eSIM avant de partir. Activation instantanée, sans carte SIM physique.',
      create_account:'Créer un compte', have_account:"J'ai déjà un compte", continue_guest:'Continuer en invité',
      login_title:'Bon retour', login_sub:'Connectez-vous pour gérer vos forfaits.', email:'Adresse e-mail', password:'Mot de passe',
      forgot:'Mot de passe oublié ?', sign_in:'Se connecter', or:'ou', no_account:'Pas encore de compte ?', signup_link:"S'inscrire",
      signup_title:'Créer un compte', signup_sub:'Rejoignez TravelConnect en 30 secondes.', full_name:'Nom complet',
      terms_notice:"En continuant, vous acceptez nos Conditions d'utilisation et notre Politique de confidentialité.",
      have_account_q:'Déjà membre ?', otp_title:'Vérification', otp_sub:'Saisissez le code envoyé au', verify:'Vérifier',
      resend:'Renvoyer le code dans', greeting:'Bienvenue', home_prompt:'Faites pivoter le globe et touchez un pays pour voir les forfaits.',
      popular:'Destinations populaires', see_all:'Tout voir', globe_hint:'Glisser · pincer pour zoomer', tab_home:'Explorer', tab_plans:'Mes forfaits', tab_history:'Historique', tab_profile:'Profil',
      operators_of:'Opérateurs disponibles', from:'dès', choose_op:'Choisissez un opérateur', plans_of:'Forfaits',
      unlimited:'Illimité', buy:'Acheter ce forfait', plan_detail:'Détail du forfait', coverage:'Couverture', validity:'Validité', speed:'Débit', esim:'eSIM · Installation instantanée',
      checkout:'Paiement', pay_method:'Mode de paiement', total:'Total à payer', pay_now:'Payer maintenant', secure:'Paiement sécurisé et chiffré',
      success_title:'Forfait activé !', success_sub:'Votre eSIM est prête. Installez-la avant votre départ.', view_plans:'Voir mes forfaits', back_home:"Retour à l'accueil",
      my_plans:'Mes forfaits', active:'Actif', expired:'Expiré', pending:'En attente', data_left:'restant', days_left:'jours restants', install_esim:"Installer l'eSIM",
      plan_active_title:'Forfait actif', used:'utilisé', of:'sur', scan_qr:'Scannez pour installer', manage:'Gérer', topup:'Recharger',
      history:'Historique', this_month:'Juillet 2026', last_month:'Juin 2026', completed:'Réussi', profile:'Profil',
      account:'Compte', settings:'Réglages', support:'Aide & support', language:'Langue', dark_mode:'Mode sombre', notifications:'Notifications',
      biometric:'Déverrouillage biométrique', help_center:"Centre d'aide", contact_us:'Nous contacter', terms:'Conditions & confidentialité',
      sign_out:'Se déconnecter', member_since:'Membre depuis 2024', edit:'Modifier', phone_lbl:'Téléphone',
    };
    const en = {
      badge:'MOBILE DATA · AFRICA', welcome_title:'Stay connected across Africa.',
      welcome_sub:'Buy your eSIM data plan before you travel. Instant activation, no physical SIM card.',
      create_account:'Create account', have_account:'I already have an account', continue_guest:'Continue as guest',
      login_title:'Welcome back', login_sub:'Sign in to manage your plans.', email:'Email address', password:'Password',
      forgot:'Forgot password?', sign_in:'Sign in', or:'or', no_account:"Don't have an account?", signup_link:'Sign up',
      signup_title:'Create account', signup_sub:'Join TravelConnect in 30 seconds.', full_name:'Full name',
      terms_notice:'By continuing, you agree to our Terms of Service and Privacy Policy.',
      have_account_q:'Already a member?', otp_title:'Verification', otp_sub:'Enter the code sent to', verify:'Verify',
      resend:'Resend code in', greeting:'Welcome back', home_prompt:'Spin the globe and tap a country to see its plans.',
      popular:'Popular destinations', see_all:'See all', globe_hint:'Drag · pinch to zoom', tab_home:'Explore', tab_plans:'My plans', tab_history:'History', tab_profile:'Profile',
      operators_of:'Available operators', from:'from', choose_op:'Choose an operator', plans_of:'Plans',
      unlimited:'Unlimited', buy:'Buy this plan', plan_detail:'Plan details', coverage:'Coverage', validity:'Validity', speed:'Speed', esim:'eSIM · Instant install',
      checkout:'Checkout', pay_method:'Payment method', total:'Total', pay_now:'Pay now', secure:'Secure, encrypted payment',
      success_title:'Plan activated!', success_sub:'Your eSIM is ready. Install it before departure.', view_plans:'View my plans', back_home:'Back to home',
      my_plans:'My plans', active:'Active', expired:'Expired', pending:'Pending', data_left:'left', days_left:'days left', install_esim:'Install eSIM',
      plan_active_title:'Active plan', used:'used', of:'of', scan_qr:'Scan to install', manage:'Manage', topup:'Top up',
      history:'History', this_month:'July 2026', last_month:'June 2026', completed:'Completed', profile:'Profile',
      account:'Account', settings:'Settings', support:'Help & support', language:'Language', dark_mode:'Dark mode', notifications:'Notifications',
      biometric:'Biometric unlock', help_center:'Help center', contact_us:'Contact us', terms:'Terms & privacy',
      sign_out:'Sign out', member_since:'Member since 2024', edit:'Edit', phone_lbl:'Phone',
    };
    return this.state.lang==='fr' ? fr : en;
  }

  // ---------- NAV ----------
  set(p){ this.setState(p); }
  toggleLang = () => this.setState(s=>({lang: s.lang==='fr'?'en':'fr'}));
  toggleTheme = () => this.setState(s=>({theme: s.theme==='dark'?'light':'dark'}));
  goWelcome = () => this.setState({screen:'welcome'});
  goLogin = () => this.setState({screen:'login'});
  goSignup = () => this.setState({screen:'signup'});
  goOtp = () => this.setState({screen:'otp'});
  goHome = () => this.setState({screen:'home', tab:'home', sheet:null});
  navHome = () => this.setState({screen:'home', tab:'home', sheet:null});
  navPlans = () => this.setState({screen:'myPlans', tab:'plans', sheet:null});
  navHistory = () => this.setState({screen:'history', tab:'history', sheet:null});
  navProfile = () => this.setState({screen:'profile', tab:'profile', sheet:null});
  openNotifs = () => this.setState({screen:'notifs'});

  openCountry = (id) => this.setState({countryId:id, operatorId:null, sheet:'operators'});
  openOperator = (id) => this.setState({operatorId:id, sheet:'plans'});
  closeSheet = () => this.setState({sheet:null});
  openPlan = (plan) => this.setState({plan, sheet:null, screen:'planDetail'});
  goCheckout = () => this.setState({screen:'checkout'});
  goSuccess = () => this.setState({screen:'success'});
  openActivePlan = () => this.setState({screen:'activePlan'});

  // ---------- GLOBE ----------
  componentDidMount(){ this._maybeGlobe(); this._maybeWelcomeGlobe(); }
  componentDidUpdate(){ this._maybeGlobe(); this._maybeWelcomeGlobe(); if(this.state.screen!=='home') this._teardownGlobe(); if(this.state.screen!=='welcome') this._teardownWelcomeGlobe(); }
  componentWillUnmount(){ this._teardownGlobe(); this._teardownWelcomeGlobe(); }

  _maybeWelcomeGlobe(){
    if(this.state.screen!=='welcome' || this._wglobe) return;
    const start = () => {
      if(!window.THREE){ this._wt = setTimeout(start, 120); return; }
      if(this.state.screen==='welcome' && this.wGlobeCanvasRef.current) this._initWelcomeGlobe();
    };
    start();
  }
  _teardownWelcomeGlobe(){
    if(this._wraf) cancelAnimationFrame(this._wraf);
    if(this._wglobe){ try{ this._wglobe.renderer.dispose(); }catch(e){} }
    this._wglobe = null; this._wraf = null;
  }

  _initWelcomeGlobe(){
    const THREE = window.THREE;
    const cv = this.wGlobeCanvasRef.current, wrap = this.wGlobeWrapRef.current;
    if(!cv||!wrap) return;
    let w = wrap.clientWidth||300, h = wrap.clientHeight||300;
    const renderer = new THREE.WebGLRenderer({canvas:cv, antialias:true, alpha:true, preserveDrawingBuffer:true});
    renderer.setPixelRatio(Math.min(window.devicePixelRatio,2));
    renderer.setSize(w,h,false);
    const scene = new THREE.Scene();
    const cam = new THREE.PerspectiveCamera(38, w/h, 0.1, 100);
    cam.position.z = 2.75;
    const group = new THREE.Group();
    scene.add(group);
    const R = 1;
    const sphereMat = new THREE.MeshPhongMaterial({color:0x21344f, emissive:0x0a1626, emissiveIntensity:0.55, specular:0x21406e, shininess:9});
    const sphere = new THREE.Mesh(new THREE.SphereGeometry(R,140,140), sphereMat);
    group.add(sphere);
    this._loadEarth(THREE, sphereMat, ()=>this._wglobe);
    // starfield
    const starGeo=new THREE.BufferGeometry(); const SN=500, sp=new Float32Array(SN*3);
    for(let i=0;i<SN;i++){ const rr=20+Math.random()*40, th=Math.random()*Math.PI*2, ph=Math.acos(2*Math.random()-1); sp[i*3]=rr*Math.sin(ph)*Math.cos(th); sp[i*3+1]=rr*Math.cos(ph); sp[i*3+2]=rr*Math.sin(ph)*Math.sin(th); }
    starGeo.setAttribute('position', new THREE.BufferAttribute(sp,3));
    scene.add(new THREE.Points(starGeo, new THREE.PointsMaterial({color:0xbcd4ff, size:0.32, transparent:true, opacity:0.75, sizeAttenuation:true})));
    // atmosphere
    const atm = new THREE.Mesh(new THREE.SphereGeometry(R*1.3,64,64), new THREE.ShaderMaterial({
      uniforms:{ c:{value:new THREE.Color(0x2f9bff)} },
      vertexShader:'varying vec3 vN; void main(){ vN=normalize(normalMatrix*normal); gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.0);}',
      fragmentShader:'varying vec3 vN; uniform vec3 c; void main(){ float i=pow(0.6-dot(vN,vec3(0.,0.,1.)),3.0); gl_FragColor=vec4(c,1.0)*i;}',
      blending:THREE.AdditiveBlending, side:THREE.BackSide, transparent:true }));
    scene.add(atm);
    // glowing served-country dots
    this.countries.forEach(c=>{
      const pos=this._ll(THREE,c.lat,c.lon,R*1.02);
      const dot=new THREE.Mesh(new THREE.SphereGeometry(0.02,12,12), new THREE.MeshBasicMaterial({color:0x37e0ff}));
      dot.position.copy(pos); group.add(dot);
      const halo=new THREE.Mesh(new THREE.SphereGeometry(0.04,12,12), new THREE.MeshBasicMaterial({color:0x37e0ff,transparent:true,opacity:0.3}));
      halo.position.copy(pos); group.add(halo);
    });
    scene.add(new THREE.AmbientLight(0x6688cc, 0.95));
    const dir=new THREE.DirectionalLight(0x9fd0ff,1.1); dir.position.set(-2,1.4,3); scene.add(dir);
    group.rotation.x = 0.36; group.rotation.y = -1.5;
    this._wglobe = { renderer, scene, cam, group };
    const animate=()=>{
      if(!this._wglobe) return;
      group.rotation.y += 0.0016;
      const nw=wrap.clientWidth, nh=wrap.clientHeight;
      if(nw&&nh&&(nw!==w||nh!==h)){ w=nw;h=nh; renderer.setSize(w,h,false); cam.aspect=w/h; cam.updateProjectionMatrix(); }
      renderer.render(scene,cam);
      this._wraf=requestAnimationFrame(animate);
    };
    animate();
  }

  _maybeGlobe(){
    if(this.state.screen!=='home' || this._globe) return;
    const start = () => {
      if(!window.THREE){ this._t = setTimeout(start, 120); return; }
      if(this.state.screen==='home' && this.globeCanvasRef.current) this._initGlobe();
    };
    start();
  }
  _teardownGlobe(){
    if(this._raf) cancelAnimationFrame(this._raf);
    if(this._globe){ try{ this._globe.renderer.dispose(); }catch(e){} }
    if(this.globeLabelsRef.current) this.globeLabelsRef.current.innerHTML='';
    this._globe = null; this._raf = null;
  }

  _ll(THREE, lat, lon, r){
    const phi=(90-lat)*Math.PI/180, th=(lon+180)*Math.PI/180;
    return new THREE.Vector3(-(r*Math.sin(phi)*Math.cos(th)), r*Math.cos(phi), r*Math.sin(phi)*Math.sin(th));
  }

  _initGlobe(){
    const THREE = window.THREE;
    const cv = this.globeCanvasRef.current, wrap = this.globeWrapRef.current;
    if(!cv||!wrap) return;
    let w = wrap.clientWidth||360, h = wrap.clientHeight||360;
    const renderer = new THREE.WebGLRenderer({canvas:cv, antialias:true, alpha:true, preserveDrawingBuffer:true});
    renderer.setPixelRatio(Math.min(window.devicePixelRatio,2));
    renderer.setSize(w,h,false);
    const scene = new THREE.Scene();
    const cam = new THREE.PerspectiveCamera(40, w/h, 0.1, 100);
    cam.position.z = 3.05;
    const group = new THREE.Group();
    scene.add(group);
    const R = 1;

    // base sphere (HD Earth texture painted from real country borders)
    const sphereMat = new THREE.MeshPhongMaterial({color:0x21344f, emissive:0x0a1626, emissiveIntensity:0.55, specular:0x21406e, shininess:9});
    const sphere = new THREE.Mesh(new THREE.SphereGeometry(R,140,140), sphereMat);
    group.add(sphere);
    this._loadEarth(THREE, sphereMat);

    // graticule (faint, under the land)
    const gmat = new THREE.LineBasicMaterial({color:0x2f6bff, transparent:true, opacity:0.08});
    for(let lat=-60; lat<=60; lat+=30){
      const pts=[]; for(let lon=-180;lon<=180;lon+=4) pts.push(this._ll(THREE,lat,lon,R*1.001));
      group.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(pts), gmat));
    }

    // starfield
    const starGeo=new THREE.BufferGeometry(); const SN=700, sp=new Float32Array(SN*3);
    for(let i=0;i<SN;i++){ const rr=26+Math.random()*44, th=Math.random()*Math.PI*2, ph=Math.acos(2*Math.random()-1); sp[i*3]=rr*Math.sin(ph)*Math.cos(th); sp[i*3+1]=rr*Math.cos(ph); sp[i*3+2]=rr*Math.sin(ph)*Math.sin(th); }
    starGeo.setAttribute('position', new THREE.BufferAttribute(sp,3));
    scene.add(new THREE.Points(starGeo, new THREE.PointsMaterial({color:0xbcd4ff, size:0.3, transparent:true, opacity:0.7, sizeAttenuation:true})));

    // atmosphere
    const atm = new THREE.Mesh(
      new THREE.SphereGeometry(R*1.28,64,64),
      new THREE.ShaderMaterial({
        uniforms:{ c:{value:new THREE.Color(0x2f9bff)} },
        vertexShader:'varying vec3 vN; void main(){ vN=normalize(normalMatrix*normal); gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.0);}',
        fragmentShader:'varying vec3 vN; uniform vec3 c; void main(){ float i=pow(0.62-dot(vN,vec3(0.,0.,1.)),3.0); gl_FragColor=vec4(c,1.0)*i;}',
        blending:THREE.AdditiveBlending, side:THREE.BackSide, transparent:true
      })
    );
    scene.add(atm);

    // markers + labels
    const markers = [];
    const labelsEl = this.globeLabelsRef.current;
    labelsEl.innerHTML='';
    this.countries.forEach(c=>{
      const pos = this._ll(THREE, c.lat, c.lon, R*1.02);
      const dot = new THREE.Mesh(new THREE.SphereGeometry(0.022,16,16), new THREE.MeshBasicMaterial({color:0x37e0ff}));
      dot.position.copy(pos); group.add(dot);
      const halo = new THREE.Mesh(new THREE.SphereGeometry(0.042,16,16), new THREE.MeshBasicMaterial({color:0x37e0ff, transparent:true, opacity:0.28}));
      halo.position.copy(pos); group.add(halo);
      const el = document.createElement('button');
      el.innerHTML = '<img src="https://flagcdn.com/w40/'+c.code+'.png" alt="" style="width:19px;height:13px;border-radius:3px;object-fit:cover;box-shadow:0 1px 3px rgba(0,0,0,.6)"/>'+c.name;
      el.style.cssText = 'position:absolute;transform:translate(-50%,-125%);display:flex;align-items:center;gap:7px;padding:5px 11px 5px 8px;border-radius:999px;background:rgba(8,14,26,.9);border:1px solid rgba(55,224,255,.45);color:#eaf0fb;font-family:Satoshi,sans-serif;font-weight:700;font-size:12px;white-space:nowrap;cursor:pointer;backdrop-filter:blur(8px);pointer-events:auto;box-shadow:0 6px 18px -6px rgba(0,0,0,.7);will-change:transform,opacity';
      el.onclick = (e)=>{ e.stopPropagation(); this.openCountry(c.id); };
      labelsEl.appendChild(el);
      markers.push({c, pos, el});
    });

    // lights
    scene.add(new THREE.AmbientLight(0x6688cc, 0.9));
    const dir = new THREE.DirectionalLight(0x9fd0ff, 1.1); dir.position.set(-2,1.4,3); scene.add(dir);

    // initial orientation: face West Africa
    group.rotation.x = 0.42;
    group.rotation.y = -1.5;

    this._globe = { renderer, scene, cam, group, markers, atm, wrap };

    // drag
    let dragging=false, lastX=0, lastY=0, vx=0;
    const down=(e)=>{ dragging=true; wrap.style.cursor='grabbing'; const p=e.touches?e.touches[0]:e; lastX=p.clientX; lastY=p.clientY; };
    const move=(e)=>{ if(!dragging) return; const p=e.touches?e.touches[0]:e; const dx=p.clientX-lastX, dy=p.clientY-lastY; group.rotation.y+=dx*0.006; group.rotation.x=Math.max(-0.9,Math.min(0.9,group.rotation.x+dy*0.005)); vx=dx*0.006; lastX=p.clientX; lastY=p.clientY; };
    const up=()=>{ dragging=false; wrap.style.cursor='grab'; };
    cv.addEventListener('pointerdown',down); window.addEventListener('pointermove',move); window.addEventListener('pointerup',up);
    // zoom: wheel + pinch
    const zoomTo=(dz)=>{ cam.position.z=Math.max(1.65,Math.min(4.6,cam.position.z+dz)); };
    const wheel=(e)=>{ e.preventDefault(); zoomTo(e.deltaY*0.0022); };
    cv.addEventListener('wheel',wheel,{passive:false});
    let pinchD=0;
    const tstart=(e)=>{ if(e.touches&&e.touches.length===2){ pinchD=Math.hypot(e.touches[0].clientX-e.touches[1].clientX,e.touches[0].clientY-e.touches[1].clientY); } };
    const tmove=(e)=>{ if(e.touches&&e.touches.length===2){ const d=Math.hypot(e.touches[0].clientX-e.touches[1].clientX,e.touches[0].clientY-e.touches[1].clientY); zoomTo((pinchD-d)*0.007); pinchD=d; e.preventDefault(); } };
    cv.addEventListener('touchstart',tstart,{passive:false}); cv.addEventListener('touchmove',tmove,{passive:false});
    this._globe.cleanup=()=>{ cv.removeEventListener('pointerdown',down); window.removeEventListener('pointermove',move); window.removeEventListener('pointerup',up); cv.removeEventListener('wheel',wheel); cv.removeEventListener('touchstart',tstart); cv.removeEventListener('touchmove',tmove); };

    const tmp = new THREE.Vector3();
    const animate = () => {
      if(!this._globe) return;
      if(!dragging){ group.rotation.y += (Math.abs(vx)>0.0005 ? (vx*=0.94) : 0.0006); }
      // resize check
      const nw=wrap.clientWidth, nh=wrap.clientHeight;
      if(nw && nh && (nw!==w||nh!==h)){ w=nw;h=nh; renderer.setSize(w,h,false); cam.aspect=w/h; cam.updateProjectionMatrix(); }
      renderer.render(scene, cam);
      // labels
      markers.forEach(m=>{
        tmp.copy(m.pos); group.localToWorld(tmp);
        const nrm = tmp.clone().normalize();
        const camDir = cam.position.clone().sub(tmp).normalize();
        const facing = nrm.dot(camDir);
        const proj = tmp.clone().project(cam);
        const x=(proj.x*0.5+0.5)*w, y=(-proj.y*0.5+0.5)*h;
        if(facing>0.12){
          m.el.style.display='block';
          m.el.style.left=x+'px'; m.el.style.top=y+'px';
          m.el.style.opacity=Math.min(1,(facing-0.12)*3.2);
        } else { m.el.style.display='none'; }
      });
      this._raf = requestAnimationFrame(animate);
    };
    animate();
  }

  _wait(cond, ms){ return new Promise((res,rej)=>{ const t0=Date.now(); const it=setInterval(()=>{ if(cond()){clearInterval(it);res();} else if(Date.now()-t0>ms){clearInterval(it);rej(new Error('timeout'));} },80); }); }

  async _loadEarth(THREE, mat, alive){
    alive = alive || (()=>this._globe);
    try{
      if(!Component._geo){
        if(!window.topojson) await this._wait(()=>window.topojson, 5000);
        const world = await fetch('https://cdn.jsdelivr.net/npm/world-atlas@2/countries-50m.json').then(r=>r.json());
        Component._geo = window.topojson.feature(world, world.objects.countries);
      }
      // yield a microtask so the caller's init finishes assigning this._globe/_wglobe
      // (when _geo is cached there is no fetch await, and the alive() ref isn't set yet)
      await Promise.resolve();
      if(!alive()) return;
      const tex = this._buildEarthTexture(THREE, Component._geo);
      mat.map = tex; mat.color.set(0xffffff); mat.emissiveIntensity = 0.32; mat.needsUpdate = true;
    }catch(e){ /* keep plain sphere on failure */ }
  }

  _buildEarthTexture(THREE, geo){
    const W=4096, H=2048;
    const cv=document.createElement('canvas'); cv.width=W; cv.height=H;
    const ctx=cv.getContext('2d');
    // ocean
    const og=ctx.createLinearGradient(0,0,0,H);
    og.addColorStop(0,'#08182e'); og.addColorStop(0.5,'#0a1f38'); og.addColorStop(1,'#08182e');
    ctx.fillStyle=og; ctx.fillRect(0,0,W,H);
    const served=new Set(this.countries.map(c=>c.iso));
    const proj=(pt)=>[ (pt[0]+180)/360*W, (90-pt[1])/180*H ];
    const pathFeat=(f)=>{
      const g=f.geometry; if(!g) return;
      const polys = g.type==='Polygon'?[g.coordinates]:g.type==='MultiPolygon'?g.coordinates:[];
      ctx.beginPath();
      polys.forEach(poly=>poly.forEach(ring=>{ ring.forEach((pt,i)=>{ const p=proj(pt); i===0?ctx.moveTo(p[0],p[1]):ctx.lineTo(p[0],p[1]); }); ctx.closePath(); }));
    };
    // base land
    ctx.lineJoin='round';
    geo.features.forEach(f=>{ if(served.has(String(f.id))) return; pathFeat(f); ctx.fillStyle='#17293f'; ctx.fill('evenodd'); ctx.lineWidth=1.5; ctx.strokeStyle='rgba(130,165,205,0.55)'; ctx.stroke(); });
    // served countries — vivid highlight with glow
    ctx.save(); ctx.shadowColor='rgba(60,224,255,0.95)'; ctx.shadowBlur=22;
    geo.features.forEach(f=>{ if(!served.has(String(f.id))) return; pathFeat(f); const gr=ctx.createLinearGradient(0,0,W,H); gr.addColorStop(0,'#2f86ff'); gr.addColorStop(1,'#37e0ff'); ctx.fillStyle=gr; ctx.fill('evenodd'); });
    ctx.restore();
    ctx.save(); ctx.shadowBlur=0;
    geo.features.forEach(f=>{ if(!served.has(String(f.id))) return; pathFeat(f); ctx.lineWidth=2.4; ctx.strokeStyle='#cdf6ff'; ctx.stroke(); });
    ctx.restore();
    const tex=new THREE.CanvasTexture(cv);
    tex.flipY=true; tex.anisotropy=8;
    if(THREE.SRGBColorSpace) tex.colorSpace=THREE.SRGBColorSpace;
    return tex;
  }

  // ---------- RENDER VALS ----------
  renderVals(){
    const st = this.state, s = this.strings;
    const cById = Object.fromEntries(this.countries.map(c=>[c.id,c]));
    const country = cById[st.countryId] || null;
    const op = st.operatorId ? this.operators[st.operatorId] : null;

    const opCount = (c)=> c.ops.length + (this.state.lang==='fr'?' opérateurs':' operators');
    const fromLabel = (c)=> s.from+' '+this.fmtPrice(c.cur, this.prices[c.cur][0]);

    const popularCountries = this.countries.slice(0,6).map(c=>({
      id:c.id, name:c.name, flag:c.flag, code:c.code, flagEl: React.createElement('img',{src:'https://flagcdn.com/w160/'+c.code+'.png',alt:'',style:{width:38,height:27,borderRadius:7,objectFit:'cover',marginBottom:12,boxShadow:'0 3px 10px rgba(0,0,0,.5)'}}), opCount: opCount(c), fromLabel: fromLabel(c), open: ()=>this.openCountry(c.id)
    }));

    const isDark = st.theme==='dark';
    const themeVars = isDark ? '' : ';--bg:#eef2f9;--bg2:#ffffff;--surface:rgba(12,22,45,.04);--surface2:rgba(12,22,45,.06);--border:rgba(12,22,45,.09);--border2:rgba(12,22,45,.14);--text:#0b1220;--dim:#586378;--faint:#8b95a8';

    const accent='#37e0ff', dim='var(--dim)';
    const initials=(nm)=>nm.split(' ').map(w=>w[0]).join('').slice(0,2).toUpperCase();
    const statusMeta=(k)=>({active:{l:s.active,c:'#2fd98a',bg:'rgba(47,217,138,.14)'},expired:{l:s.expired,c:'#ff7a86',bg:'rgba(255,92,108,.13)'},pending:{l:s.pending,c:'#ffb23e',bg:'rgba(255,178,62,.14)'},completed:{l:s.completed,c:'#2fd98a',bg:'rgba(47,217,138,.14)'},failed:{l:st.lang==='fr'?'Échoué':'Failed',c:'#ff7a86',bg:'rgba(255,92,108,.13)'}})[k];

    // sheet: operators + plans
    let sc=null, currentOperators=[], so=null, currentPlans=[];
    if(country){
      sc={ name:country.name, flag:country.flag, code:country.code, flagEl: React.createElement('img',{src:'https://flagcdn.com/w160/'+country.code+'.png',alt:'',style:{width:48,height:34,borderRadius:9,objectFit:'cover',boxShadow:'0 4px 12px rgba(0,0,0,.5)'}}), sub: country.ops.length+(st.lang==='fr'?' opérateurs · ':' operators · ')+s.from+' '+this.fmtPrice(country.cur,this.prices[country.cur][0]) };
      currentOperators = country.ops.map(oid=>{ const o=this.operators[oid]; return { id:oid, name:o.name, badge:o.c, badgeText:o.t, initial:initials(o.name), sub:(st.lang==='fr'?'Forfaits dès ':'Plans from ')+this.fmtPrice(country.cur,this.prices[country.cur][0]), open:()=>this.openOperator(oid) }; });
    }
    if(country && op){
      so={ name:op.name, badge:op.c, badgeText:op.t, initial:initials(op.name), country:country.name, flag:country.flag, code:country.code, flagEl: React.createElement('img',{src:'https://flagcdn.com/w160/'+country.code+'.png',alt:'',style:{width:18,height:13,borderRadius:3,objectFit:'cover'}}) };
      currentPlans = this.planSpecs.map((sp,i)=>{ const price=this.fmtPrice(country.cur,this.prices[country.cur][i]); const dur=st.lang==='fr'?sp.dur_fr:sp.dur_en; const plan={ countryName:country.name, countryFlag:country.flag, countryCode:country.code, countryFlagUrl:'https://flagcdn.com/w160/'+country.code+'.png', opName:op.name, opColor:op.c, opText:op.t, opInitial:initials(op.name), data:sp.data, dur, priceLabel:price }; return { id:i, data:sp.data, dur, priceLabel:price, hot:i===1, open:()=>this.openPlan(plan) }; });
    }
    const pl = st.plan || null;

    // payments
    const payMeta=[
      {id:'momo',name:'MTN MoMo',c:'#FFCC00',t:'#1a1500',tag:'Mobile Money'},
      {id:'orange',name:'Orange Money',c:'#FF7900',t:'#fff',tag:'Mobile Money'},
      {id:'moov',name:'Moov Money',c:'#0a58ca',t:'#fff',tag:'Mobile Money'},
      {id:'wave',name:'Wave',c:'#1DC4F5',t:'#00263a',tag:'Mobile Money'},
      {id:'card',name:st.lang==='fr'?'Carte bancaire':'Bank card',c:'#e9edf5',t:'#0b1220',tag:'Visa · Mastercard'},
    ];
    const payments=payMeta.map(p=>({...p, initial:p.name[0], sel: st.pay===p.id, selRing: st.pay===p.id?'var(--accent2)':'var(--border)', choose:()=>this.setState({pay:p.id})}));
    const selPay=payMeta.find(p=>p.id===st.pay)||payMeta[0];

    // my plans
    const mp=[
      {country:'Sénégal',flag:'🇸🇳',code:'sn',op:'Orange',c:'#FF7900',data:'6 Go',usedPct:38,left:'3,7 Go',days:5,status:'active'},
      {country:'Ghana',flag:'🇬🇭',code:'gh',op:'MTN',c:'#FFCC00',data:'15 Go',usedPct:72,left:'4,2 Go',days:18,status:'active'},
      {country:"Côte d'Ivoire",flag:'🇨🇮',code:'ci',op:'Orange',c:'#FF7900',data:'6 Go',usedPct:100,left:'0 Go',days:0,status:'expired'},
    ];
    const myPlansList=mp.map(p=>{ const m=statusMeta(p.status); return {...p, flagEl: React.createElement('img',{src:'https://flagcdn.com/w160/'+p.code+'.png',alt:'',style:{width:36,height:26,borderRadius:6,objectFit:'cover',boxShadow:'0 2px 8px rgba(0,0,0,.5)'}}), stLabel:m.l, stColor:m.c, stBg:m.bg, barW:p.usedPct+'%', leftLabel:p.left+' '+s.data_left, daysLabel:p.status==='expired'?s.expired:(p.days+' '+s.days_left), open:this.openActivePlan}; });
    const ringPct=62;
    const activeRing='conic-gradient(var(--accent2) '+ringPct+'%, rgba(255,255,255,.08) 0)';

    // history
    const hist=[
      {month:s.this_month, items:[
        {flag:'🇸🇳',code:'sn',country:'Sénégal',op:'Orange',data:'6 Go',amount:'3 500 FCFA',status:'completed',date:st.lang==='fr'?'2 juil.':'Jul 2',pay:'MTN MoMo'},
        {flag:'🇬🇭',code:'gh',country:'Ghana',op:'MTN',data:'15 Go',amount:'₵99',status:'completed',date:st.lang==='fr'?'1 juil.':'Jul 1',pay:'Wave'},
      ]},
      {month:s.last_month, items:[
        {flag:'🇨🇮',code:'ci',country:"Côte d'Ivoire",op:'Orange',data:'6 Go',amount:'3 500 FCFA',status:'pending',date:st.lang==='fr'?'28 juin':'Jun 28',pay:'Orange Money'},
        {flag:'🇳🇬',code:'ng',country:'Nigeria',op:'MTN',data:'1,5 Go',amount:'₦900',status:'failed',date:st.lang==='fr'?'19 juin':'Jun 19',pay:st.lang==='fr'?'Carte':'Card'},
        {flag:'🇧🇯',code:'bj',country:'Bénin',op:'Celtiis',data:'15 Go',amount:'7 900 FCFA',status:'completed',date:st.lang==='fr'?'12 juin':'Jun 12',pay:'Moov Money'},
      ]},
    ];
    const historyGroups=hist.map(g=>({month:g.month, items:g.items.map(it=>{ const m=statusMeta(it.status); return {...it, flagEl: React.createElement('img',{src:'https://flagcdn.com/w160/'+it.code+'.png',alt:'',style:{width:32,height:23,borderRadius:6,objectFit:'cover',boxShadow:'0 2px 8px rgba(0,0,0,.45)'}}), stLabel:m.l, stColor:m.c, stBg:m.bg, sub:it.op+' · '+it.data}; })}));
    const plFlagEl = pl ? React.createElement('img',{src:pl.countryFlagUrl,alt:'',style:{width:18,height:13,borderRadius:3,objectFit:'cover'}}) : null;

    const user={ name:'Aïssatou Diallo', email:'aissatou@travelconnect.io', phone:'+221 77 123 45 42', since:s.member_since, initials:'AD' };
    const darkOn=st.theme==='dark';
    const nIcon=(color,path)=>React.createElement('svg',{width:20,height:20,viewBox:'0 0 24 24',fill:'none',stroke:color,strokeWidth:1.9,strokeLinecap:'round',strokeLinejoin:'round'},React.createElement('path',{d:path}));
    const notifRaw=[
      {c:'#2fd98a',bg:'rgba(47,217,138,.14)',p:'M20 6L9 17l-5-5',title:st.lang==='fr'?'Forfait activé':'Plan activated',body:st.lang==='fr'?'Votre eSIM Orange 6 Go pour le Sénégal est prête à installer.':'Your Orange 6 GB eSIM for Senegal is ready to install.',time:st.lang==='fr'?'Il y a 2 min':'2 min ago',unread:true},
      {c:'#ffb23e',bg:'rgba(255,178,62,.14)',p:'M10.3 3.9 2 18a2 2 0 0 0 1.7 3h16.6a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0zM12 9v4M12 17h.01',title:st.lang==='fr'?'Data bientôt épuisée':'Low data',body:st.lang==='fr'?'Il vous reste 15% sur votre forfait Ghana (MTN).':'15% left on your Ghana plan (MTN).',time:st.lang==='fr'?'Il y a 1 h':'1 h ago',unread:true},
      {c:'#37e0ff',bg:'rgba(55,224,255,.14)',p:'M2 7h20v10H2zM2 11h20',title:st.lang==='fr'?'Paiement réussi':'Payment successful',body:st.lang==='fr'?'3 500 FCFA débités via MTN MoMo.':'3,500 FCFA charged via MTN MoMo.',time:st.lang==='fr'?'Hier':'Yesterday',unread:false},
      {c:'#7f9bff',bg:'var(--accent-soft)',p:'M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9M13.7 21a2 2 0 0 1-3.4 0',title:st.lang==='fr'?'Bienvenue sur TravelConnect':'Welcome to TravelConnect',body:st.lang==='fr'?"Explorez les forfaits data dans 8 pays d'Afrique de l'Ouest.":'Explore data plans across 8 West African countries.',time:st.lang==='fr'?'Il y a 2 j':'2 days ago',unread:false},
    ];
    const notifs=notifRaw.map(n=>({...n, iconEl: React.createElement('div',{style:{width:42,height:42,borderRadius:13,background:n.bg,display:'flex',alignItems:'center',justifyContent:'center',flexShrink:0}}, nIcon(n.c,n.p)), dotDisplay:n.unread?'block':'none', rowBg:n.unread?'var(--surface2)':'transparent'}));

    return {
      s, themeVars, langLabel: st.lang==='fr'?'FR':'EN',
      toggleLang:this.toggleLang, toggleTheme:this.toggleTheme,
      goWelcome:this.goWelcome, goLogin:this.goLogin, goSignup:this.goSignup, goOtp:this.goOtp, goHome:this.goHome, goGuest:this.goHome,
      navHome:this.navHome, navPlans:this.navPlans, navHistory:this.navHistory, navProfile:this.navProfile,
      closeSheet:this.closeSheet, backToOperators:()=>this.setState({sheet:'operators'}), goCheckout:this.goCheckout, goSuccess:this.goSuccess, openActivePlan:this.openActivePlan,
      isWelcome: st.screen==='welcome', isLogin: st.screen==='login', isSignup: st.screen==='signup', isOtp: st.screen==='otp', isHome: st.screen==='home',
      openNotifs:this.openNotifs, isNotifs: st.screen==='notifs', notifs,
      isPlanDetail: st.screen==='planDetail', isCheckout: st.screen==='checkout', isSuccess: st.screen==='success', isMyPlans: st.screen==='myPlans', isActivePlan: st.screen==='activePlan', isHistory: st.screen==='history', isProfile: st.screen==='profile',
      sheetOperators: st.sheet==='operators', sheetPlans: st.sheet==='plans',
      showNav: ['home','myPlans','history','profile'].includes(st.screen) && !st.sheet,
      homeColor: st.tab==='home'?accent:dim, plansColor: st.tab==='plans'?accent:dim, historyColor: st.tab==='history'?accent:dim, profileColor: st.tab==='profile'?accent:dim,
      globeWrapRef:this.globeWrapRef, globeCanvasRef:this.globeCanvasRef, globeLabelsRef:this.globeLabelsRef,
      wGlobeWrapRef:this.wGlobeWrapRef, wGlobeCanvasRef:this.wGlobeCanvasRef,
      popularCountries, sc, currentOperators, so, currentPlans, pl, plFlagEl,
      payments, selPay, myPlansList, activeRing, historyGroups, user, darkOn,
      qrCells:this.qr,
      darkTrack: darkOn?'var(--accent)':'rgba(255,255,255,.14)', darkJustify: darkOn?'flex-end':'flex-start',
    };
  }
}
