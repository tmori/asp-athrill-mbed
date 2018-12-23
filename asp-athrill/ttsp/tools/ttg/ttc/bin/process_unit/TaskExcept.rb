#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
#  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
#  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
#  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
#      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
#      スコード中に含まれていること．
#  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
#      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
#      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
#      の無保証規定を掲載すること．
#  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
#      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
#      と．
#    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
#        作権表示，この利用条件および下記の無保証規定を掲載すること．
#    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
#        報告すること．
#  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
#      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
#      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
#      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
#      免責すること．
#
#  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
#  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
#  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
#  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
#  の責任を負わない．
#
#  $Id: TaskExcept.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "ttc/bin/process_unit/ProcessUnit.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # クラス名: TaskExcept
  # 概    要: タスク例外の情報を処理するクラス
  #===================================================================
  class TaskExcept < ProcessUnit
    #=================================================================
    # 概  要: オブジェクトチェック
    #=================================================================
    def object_check(bIsPre)
      check_class(Bool, bIsPre)  # pre_conditionか

      aErrors = []
      begin
        super(bIsPre)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      # hdlstatがACTIVATE
      if (@hState[TSR_PRM_HDLSTAT] == TSR_STT_ACTIVATE)
        ### T3_TEX001: hdlstatがACTIVATEの時にtexptnが指定されていない
        if (@hState[TSR_PRM_TEXPTN].nil?())
          aErrors.push(YamlError.new("T3_TEX001: " + ERR_NO_TEXPTN_ON_ACTIVATE, @aPath))
        ### T3_TEX002: hdlstatがACTIVATEの時にtexptnが0
        elsif (@hState[TSR_PRM_TEXPTN] == 0)
          aErrors.push(YamlError.new("T3_TEX002: " + ERR_TEXPTN_0_ON_ACTIVATE, @aPath))
        end
        ### T3_TEX003: hdlstatがACTIVATEのとき，pndptnが0でない かつ texstatがTTEX_ENA
        if (@hState[TSR_PRM_PNDPTN] != 0 && @hState[TSR_PRM_STATE] == TSR_STT_TTEX_ENA)
          aErrors.push(YamlError.new("T3_TEX003: " + ERR_SET_PNDPTN_ON_ENABLE, @aPath))
        end
      ### T3_TEX004: hdlstatがACTIVATE-waitspinの時にspinidが指定されていない
      elsif (@hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN && @hState[TSR_PRM_SPINID].nil?())
        aErrors.push(YamlError.new("T3_TEX004: " + ERR_NO_SPINID_WAITING, @aPath))
      end

      check_error(aErrors)
    end

    #=================================================================
    # 概  要: 初期値を補完する
    #=================================================================
    def complement_init_object_info()
      hMacro  = @cConf.get_macro()

      # bootcnt
      unless (is_specified?(TSR_PRM_BOOTCNT))
        @hState[TSR_PRM_BOOTCNT] = 0
      end
    end
  end
end
