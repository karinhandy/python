\\wallet profit dune
SELECT
MIN((CASE
    WHEN token_bought_symbol IN ('WETH','USDC','USDT','ETH','DAI') THEN token_sold_symbol
    -- WHEN token_bought_symbol='' THEN cast(token_bought_address as varchar)
    WHEN token_bought_symbol IS NULL OR token_bought_symbol = '' OR LENGTH(token_bought_symbol) = 0 THEN cast(token_bought_address as varchar)
    ELSE token_bought_symbol
    -- else if nullif(token_bought_symbol,'ZZZ') THEN 
    END
)) as shitcoin,
project_contract_address,
COUNT(DISTINCT tx_hash) as txs,
SUM((CASE
    WHEN token_bought_symbol IN ('WETH','USDC','USDT','ETH','DAI') THEN 1
    ELSE -1
    END
) * amount_usd) as profit
FROM dex.trades
WHERE 
1=1
AND YEAR(block_date) >= 2023
AND blockchain = 'ethereum'
AND amount_usd > 0 AND (token_bought_amount > 0 OR token_sold_amount > 0)
AND tx_from = {{wallet}}
GROUP BY project_contract_address
ORDER BY profit DESC
