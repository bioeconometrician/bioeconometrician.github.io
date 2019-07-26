rm(list=ls())
pkgs <- c('readxl','data.table','magrittr','stringr','forcats','cowplot')
for (pp in pkgs) library(pp, character.only = T)

dir <- 'C:/Users/erikinwest/Documents/Research/property/houses'
setwd(dir)

# Load TSX data
dat_tsx <- fread('tse.csv')
dat_tsx[, Date := as.Date(Date)]
dat_tsx[, `:=` (Year = as.numeric(format(Date,'%Y')))]
# Get average by year
ret_tsx <- dat_tsx[, list(price=mean(Close)),by=Year]
# Calculate the return to the most recent price
tsx_2019 <- ret_tsx[Year == max(Year)]$price
ret_tsx[, `:=` (price_2019 = tsx_2019, nyears = (2019-Year) ) ]
ret_tsx[, ann_ret := (price_2019 / price)^(1/nyears)-1]
ret_tsx <- ret_tsx[nyears > 0]

# Load Teranet
slice1 <- as.character(unlist(fread('teranet.csv',nrows = 1,header=F)))
slice2 <- as.character(unlist(fread('teranet.csv',nrows = 1,header=F,skip=1)))
dat_tera <- fread('teranet.csv',skip=2,header=F)
colnames(dat_tera)[which(!is.na(slice1))] <- slice1[!is.na(slice1)]
dat_tera <- dat_tera[,c(1,which(slice2 == 'Index')),with=F]
setnames(dat_tera,'Transaction Date','Date')
dat_tera[, Year := as.numeric(str_split_fixed(Date,'\\-',2)[,2])]
# dat_tera <- dat_tera[,str_detect(colnames(dat_tera),'\\_|Year'),with=F]
colnames(dat_tera) <- str_remove(colnames(dat_tera),'^[a-z]{2}\\_')
colnames(dat_tera) <-
unlist(lapply(colnames(dat_tera),function(cc) str_c(unlist(lapply(str_split(cc,'\\_'), 
            function(ll) str_c(toupper(str_sub(ll,1,1)),
      str_sub(ll,2,str_length(ll))))),collapse = ' ')))
# Extract for y/y later
yy_tera <- dat_tera; yy_tera[, Year := NULL]
yy_tera <- melt(yy_tera,id.vars = 'Date',variable.name = 'City')[!is.na(value)]
yy_tera[, lvalue := shift(value,n=12,type = 'lag') ,by=list(City)]
yy_tera <- yy_tera[!is.na(lvalue)]
yy_tera[, yy_ret := value / lvalue - 1]
yy_tera[yy_tera[,.I[yy_ret == max(yy_ret)],by=City]$V1]
# Continue
dat_tera[, Date := NULL]
dat_tera <- melt(dat_tera,id.vars = 'Year',variable.name = 'City')
dat_tera <- dat_tera[City != 'C6']
ret_tera <- dat_tera[!is.na(value),list(index=mean(value)),by=list(City,Year)]
ret_tera[, nyears := max(Year) - Year,by=City]
ret_tera <- merge(ret_tera,setnames(ret_tera[nyears==0,c('City','index')],'index','imax'),by='City')
ret_tera[, ann_ret := (imax / index)^(1/nyears) - 1]
ret_tera <- ret_tera[nyears != 0]
# Calculat Y-Y data


# Load CREA
snames <- readxl::excel_sheets('crea.xlsx')
spick <- c('Aggregate','Victoria','Greater_Vancouver','Calgary','Edmonton',
           'Regina','Saskatoon','Guelph','Hamilton_Burlington','Oakville_Milton',
           'Barrie_and_District','Greater_Toronto','Ottawa','Greater_Montreal',
           'Greater_Moncton')
stopifnot( all ( spick %in% snames ) )

lst_df <- lapply(spick, function(ss) data.table(read_xlsx(path='crea.xlsx',sheet=ss)) )
cn.keep <- c('Date','Composite_HPI','Single_Family_HPI','Apartment_HPI')
dat_crea <- rbindlist(mapply(function(df, nn) data.table(df[,cn.keep,with=F],City=nn) ,
       lst_df,spick,SIMPLIFY = F))
dat_crea[, `:=` (Year =as.numeric(format(as.Date(Date),'%Y')), Date=NULL)]
dat_crea[, City := str_split_fixed(str_remove(City,'Greater\\_'),'\\_',2)[,1]]
dat_crea <- melt(dat_crea,id.vars = c('City','Year'),variable.name = 'Type')
dat_crea[, Type := as.character(str_replace(str_remove(Type,'\\_HPI'),'\\_','-'))]
ret_crea <- dat_crea[,list(index=mean(value)),by=list(City,Type,Year)]
ret_crea[, nyears := max(Year) - Year, by=list(City,Type)]
ret_crea <- merge(ret_crea,setnames(ret_crea[nyears == 0,c('City','Type','index')],'index','imax'),
      by=c('City','Type'))
ret_crea[, ann_ret := (imax / index)^(1/nyears) - 1]
ret_crea <- ret_crea[nyears > 0]

# # MERGE!
# head(ret_tera)
# head(ret_tsx)
# ret_all <- merge(ret_tera[,c('City','Year','ann_ret')],
#       ret_tsx[,c('Year','ann_ret')],by=c('Year'),suffixes=c('_city','_tsx'))

# Plot it!
gg.tera <-
ggplot(ret_tera,aes(x=Year,y=ann_ret,color=City,group=City)) + 
  geom_point() + geom_line() + guides(color=F) + 
  facet_wrap(~City) + background_grid(major='xy',minor='none') + 
  geom_point(data=ret_tsx,aes(x=Year,y=ann_ret),
             color='black',inherit.aes = F) + 
  labs(y='Annualized return to 2019 index',title='Teranet HPI  (1990-2018)',
       subtitle = 'Block dots show TSX/S&P benchmark')
save_plot('gg_tera.png',gg.tera,base_height = 8,base_width = 12)

gg.crea <-
ggplot(ret_crea,aes(x=Year,y=ann_ret,color=Type,group=Type)) + 
  geom_point() + geom_line() + 
  scale_color_discrete(name='Housing Type: ') + 
  theme(legend.position = 'bottom',legend.justification = 'center') +
  facet_wrap(~City) + background_grid(major='xy',minor='none') + 
  labs(y='Annualized return to 2019 index',title='CREA HPI price (2005-2018)',
       subtitle = 'Block dots show TSX/S&P benchmark') + 
  geom_point(data=ret_tsx[Year >= min(ret_crea$Year)],aes(x=Year,y=ann_ret),
             color='black',inherit.aes = F)
save_plot('gg_crea.png',gg.crea,base_height = 8,base_width = 12)  



