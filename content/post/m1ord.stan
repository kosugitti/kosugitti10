data{
  int<lower=0> L; //データ長
  int P;          //演者数
  int R;          //審査員数
  int Pid[L];     //演者 ID
  int Ord[L];     //ネタ順
  int Rid[L];     //審査員 ID
  real  Y[L];     //スコア
}

parameters{
  real theta[P];                // 演者の実力
  real<lower=0,upper=100> mu;   // 実力の事前分布
  real tau_pre[9];              // 順番の効果(自由度分)
  real<lower=0> sig;            // 実力が発揮できるかな？誤差成分
  real<lower=0> phi[R];         // 審査員のブレ
  real<lower=0> phi_mu;         // 審査員のブレの平均
}

transformed parameters{
  real tau[10];                 // 順番の効果(1番手から10番手まで)
  tau[1:9] = tau_pre;
  tau[10] = 0-sum(tau_pre);     // 順番の効果は相対的で，総和が0の縛りをかける
}

model{
  // 尤度
  for(l in 1:L){
    Y[l] ~ normal( theta[Pid[l]]+tau[Ord[l]] , phi[Rid[l]] );
  }
  
  //事前分布
  theta ~ normal(mu,sig);
  mu ~ normal(0,100);
  sig ~ cauchy(0,5);
  phi ~ cauchy(phi_mu,5);
}
